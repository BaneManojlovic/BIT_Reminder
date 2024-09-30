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
    @StateObject private var profileVC = ProfileViewModel()

    var isUpdateButtonDisabled: Bool {
        profileVC.username.isEmpty ||
        profileVC.email.isEmpty ||
        (profileVC.username == initialUsername &&
         profileVC.email == initialEmail &&
         !isImageChanged) ||
        profileVC.isFormNotValid
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
                    text: $profileVC.username,
                    placeholderText: "",
                    isFormNotValid: $profileVC.isFormNotValid,
                    fieldContentType: .nameInvalid,
                    isInputValid: $profileVC.profileValidation,
                    isEditMode: isEditindModeOn
                )
                .foregroundStyle(.white)
                .disabled(disableTextField)

                // Email Field
                BaseCustomTextFieldView(
                    text: $profileVC.email,
                    placeholderText: "",
                    isFormNotValid: $profileVC.isFormNotValid,
                    fieldContentType: .emailInvalid,
                    isInputValid: $profileVC.profileValidation,
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
                    .background(Color("textfield_blue_color"))
                    .foregroundColor(Color.white)
                    .clipShape(Capsule())
                    .padding(.horizontal, 30)

                    Button(L10n.labelDeleteAccount) {
                        activeAlert = .deleteConfirmation
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("textfield_blue_color"))
                    .foregroundColor(Color.red)
                    .clipShape(Capsule())
                    .padding(.horizontal, 30)

                    Spacer()
                        .frame(height: 40)

                    VStack {
                        if isEditindModeOn {
                            Button(L10n.titleLabelUpdatePassword) {
                                profileVC.updateProfileButtonTapped()
                            }
                            // Disable button unless there's a change or inputs are invalid
                            .disabled(isUpdateButtonDisabled)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("darkOrange"))
                            .clipShape(Capsule())
                            .padding(.horizontal, 30)

                            if isLoading {
                                ProgressView()
                            }
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                .onChange(of: profileVC.profileUpdateSuccess) { success in
                    if success || profileVC.errorMessage != nil {
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
                                profileVC.deleteUser()
                            },
                            secondaryButton: .cancel()
                        )
                    case .profileUpdate:
                        return Alert(
                            title: Text(profileVC.profileUpdateSuccess ? L10n.alertMessageProfileUpdated : "Error"),
                            message: Text(profileVC.profileUpdateSuccess ? L10n.alertMessageProfileSuccess : profileVC.errorMessage ?? L10n.alertTitleUnknownMessage),
                            dismissButton: .default(Text(L10n.alertButtonTitleOk)) {
                                if profileVC.profileUpdateSuccess {
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
            .background(Color("background_blue_color"))
        }
        .background(Color("background_blue_color"))
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
            // Set the initial values once the profile is loaded
            initialUsername = profileVC.username
            initialEmail = profileVC.email
            initialImageData = profileVC.avatarImage?.data // Track initial image data
            Task {
                await profileVC.getInitialProfile()
            }
        }
        .onChange(of: editMode?.wrappedValue, perform: handleEditModeChange)

    }

    // Extracted function for profile image view
    private func profileImageView() -> some View {
        ZStack {
            Spacer().frame(height: 30)
            Group {
                if let avatarImage = profileVC.avatarImage {
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
                        .background(Color("textfield_blue_color"))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .background(Color("background_blue_color"))
    }

    private func handleEditModeChange(_ newValue: EditMode?) {
        if let mode = newValue {
            if mode.isEditing {
                initialUsername = profileVC.username
                initialEmail = profileVC.email
                initialImageData = profileVC.avatarImage?.data
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
            initialUsername = profileVC.username
            initialEmail = profileVC.email
            initialImageData = profileVC.avatarImage?.data // Track initial image data
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
                profileVC.avatarImage = try await imageSelection.loadTransferable(type: AvatarImage.self)
                // Compare new image data with the initial one
                if let newData = profileVC.avatarImage?.data, newData != initialImageData {
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
