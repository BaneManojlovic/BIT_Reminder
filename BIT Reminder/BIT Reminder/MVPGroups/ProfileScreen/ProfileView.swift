//
//  ProfileView.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 7.5.24..
//
import SwiftUI
import PhotosUI
import Supabase
import KRProgressHUD

struct ProfileView: View {

    @Environment(\.editMode) private var editMode
    weak var navigationController: UINavigationController?
    @Environment(\.dismiss) var dismiss
    @StateObject private var alertManager = AlertManager.shared
    @StateObject private var profileViewModel = ProfileViewModel()

    var userDefaultsHelper = UserDefaultsHelper()

    var isUpdateButtonDisabled: Bool {
        profileViewModel.username.isEmpty ||
        profileViewModel.email.isEmpty ||
        (profileViewModel.username == initialUsername &&
         profileViewModel.email == initialEmail &&
         !isImageChanged) ||
        profileViewModel.isFormNotValid
    }

    @State private var activeAlert: ActiveAlert?
    @State var isLoading = false
    @State var isEditindModeOn = false
    @State var disableTextField = true
    @State var imageSelection: PhotosPickerItem?

    // Track initial values
    @State private var initialUsername = ""
    @State private var initialEmail = ""
    @State private var initialImageData: Data?

    // Track if image has changed
    @State private var isImageChanged = false
    var body: some View {
        ScrollView {
            VStack {
                profileImageView()

                // Username Field
                BaseCustomTextFieldView(
                    text: $profileViewModel.username,
                    title: "",
                    placeholderText: "",
                    isFormNotValid: $profileViewModel.isFormNotValid,
                    fieldContentType: .nameInvalid,
                    isInputValid: $profileViewModel.profileValidation,
                    isEditMode: isEditindModeOn
                )
                .foregroundStyle(.white)
                .disabled(disableTextField)

                // Email Field
                BaseCustomTextFieldView(
                    text: $profileViewModel.email,
                    title: "",
                    placeholderText: "",
                    isFormNotValid: $profileViewModel.isFormNotValid,
                    fieldContentType: .emailInvalid,
                    isInputValid: $profileViewModel.profileValidation,
                    isEditMode: isEditindModeOn
                )
                .foregroundStyle(.white)
                .disabled(disableTextField)

                Spacer()
                    .frame(height: 40)

                VStack(alignment: .center, spacing: 20) {
                    NavigationLink {
                        ChangePasswordView()
                    } label: {
                        Text(L10n.titleLabelChangePassword)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(Asset.textfieldBlueColor.color))
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())

                    Button(L10n.labelDeleteAccount) {
                        activeAlert = .deleteConfirmation
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(Asset.textfieldBlueColor.color))
                    .foregroundColor(Color.red)
                    .clipShape(Capsule())

                    VStack {
                        if isEditindModeOn {
                            Button(L10n.titleLabelUpdatePassword) {
                                profileViewModel.updateProfileButtonTapped()
                            }
                            // Disable button unless there's a change or inputs are invalid
                            .disabled(isUpdateButtonDisabled)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(Asset.darkOrange.color))
                            .foregroundStyle(isUpdateButtonDisabled ? Color(Asset.disabledDarkGrayColor.color) : .white)
                            .clipShape(Capsule())

                            if isLoading {
                                ProgressView()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .onChange(of: profileViewModel.profileUpdateSuccess) { success in
                    if success || profileViewModel.errorMessage != nil {
                        activeAlert = .profileUpdate
                    }
                }
                .alert(item: $activeAlert) { alertType in
                    switch alertType {
                    case .deleteConfirmation:
                        return Alert(
                            title: Text(L10n.labelMessageSureWantDeleteAccount),
                            message: Text(""),
                            primaryButton: .destructive(Text(L10n.titleLabelDelete)) {
                                profileViewModel.deleteUser()
                            },
                            secondaryButton: .cancel()
                        )
                    case .profileUpdate:
                        return Alert(
                            title: Text(profileViewModel.profileUpdateSuccess ? L10n.alertMessageProfileUpdated : "Error"),
                            message: Text(profileViewModel.profileUpdateSuccess ? L10n.alertMessageProfileSuccess : profileViewModel.errorMessage ?? L10n.alertTitleUnknownMessage),
                            dismissButton: .default(Text(L10n.alertButtonTitleOk)) {
                                if profileViewModel.profileUpdateSuccess {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        )
                    }
                }

                .onChange(of: imageSelection) { newValue in
                    guard let newValue = newValue else { return }
                    loadTransferable(from: newValue)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color(Asset.backgroundBlueColor.color))
        }
        .background(Color(Asset.backgroundBlueColor.color))
        .navigationTitle(isEditindModeOn ? L10n.titleLabelEditProfile : L10n.titleLabelProfile)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)

        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.navigationController?.popViewController(animated: true)
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    toggleEditMode()
                }) {
                    Text(isEditindModeOn ? L10n.labelTitleDone : L10n.labelTitleEdit)
                        .foregroundStyle(isEditindModeOn ? .red : .white)
                }
            }
        }
        .onAppear {
            // Set initial values from local cache before fetching data
            initialUsername = userDefaultsHelper.getUser()?.userName ?? "No data"
            initialEmail = userDefaultsHelper.getUser()?.userEmail ?? "No data"
            Task {
                await profileViewModel.getInitialProfile()
            }
        }
        .onChange(of: editMode?.wrappedValue, perform: handleEditModeChange)
        .alert(isPresented: $alertManager.showAlert) {
                Alert(title: Text(alertManager.alertMessage), message: Text(""), dismissButton: .default(Text("OK")))
            }
    }

    // Extracted function for profile image view
    private func profileImageView() -> some View {
        ZStack {
            Spacer().frame(height: 30)
            Group {
                if let avatarImage = profileViewModel.avatarImage {
                    avatarImage.image.resizable()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .foregroundStyle(Color.white)
                }
            }
            .clipShape(Circle())
            .shadow(radius: 10)
            .frame(width: 130, height: 130)
            .frame(maxWidth: .infinity, alignment: .center)

            Spacer().frame(height: 10)

            if isEditindModeOn {
                PhotosPicker(selection: $imageSelection, matching: .images) {
                    Image(systemName: "photo.badge.plus")
                        .frame(width: 50, height: 50)
                        .background(Color(Asset.textfieldBlueColor.color))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .background(Color(Asset.backgroundBlueColor.color))
    }

    private func handleEditModeChange(_ newValue: EditMode?) {
        if let mode = newValue {
            if mode.isEditing {
                initialUsername = profileViewModel.username
                initialEmail = profileViewModel.email
                initialImageData = profileViewModel.avatarImage?.data
                disableTextField = false
            } else {
                disableTextField = true
                isImageChanged = false
            }
            isEditindModeOn = mode.isEditing
        }
    }

    private func toggleEditMode() {
        isEditindModeOn.toggle()
        if isEditindModeOn {
            // Set initial values when entering edit mode
            initialUsername = profileViewModel.username
            initialEmail = profileViewModel.email
            initialImageData = profileViewModel.avatarImage?.data // Track initial image data
            disableTextField = false
        } else {
            // Disable text fields when exiting edit mode
            disableTextField = true
            isImageChanged = false // Reset image change flag
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) {
        Task {
            do {
                profileViewModel.avatarImage = try await imageSelection.loadTransferable(type: AvatarImage.self)
                // Compare new image data with the initial one
                if let newData = profileViewModel.avatarImage?.data, newData != initialImageData {
                    isImageChanged = true
                } else {
                    isImageChanged = false
                }
            } catch {
                debugPrint(error)
            }
        }
    }
}
