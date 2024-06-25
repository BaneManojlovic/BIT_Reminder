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

// swiftlint: disable trailing_whitespace vertical_whitespace

struct ProfileView: View {
    @Environment(\.editMode) private var editMode
    
    weak var navigationController: UINavigationController?

    @StateObject private var profileVC = ProfileViewModel()

    @State var isLoading = false
    @State var isEditindModeOn = false
    @State var disableTextField = true
    @State var imageSelection: PhotosPickerItem?
    @State private var showingAlert = false

    // Track initial values
    @State private var initialUsername: String = ""
    @State private var initialEmail: String = ""

    // Track image change
    @State private var isImageChanged = false

    var body: some View {
        ScrollView {
            VStack {
                // Avatar and Image Picker
                ZStack {
                    Spacer()
                        .frame(height: 30)
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

                    Spacer()
                        .frame(height: 10)

                    if isEditindModeOn {
                        PhotosPicker(selection: $imageSelection, matching: .images) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .blur(radius: 1)
                        }
                    }
                }
                .background(Color("background_blue_color"))

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
                        showingAlert = true
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            // Disable button unless there's a change or inputs are invalid
                            .disabled(
                                profileVC.username.isEmpty ||
                                profileVC.email.isEmpty ||
                                (profileVC.username == initialUsername && profileVC.email == initialEmail && !isImageChanged) ||
                                profileVC.isFormNotValid
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.orange)
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

                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text(L10n.labelMessageSureWantDeleteAccount),
                        message: Text(""),
                        primaryButton: .destructive(Text(L10n.titleLabelDelete)) {
                            profileVC.deleteUser()
                        },
                        secondaryButton: .cancel()
                    )
                }

                .onChange(of: imageSelection) { newValue in
                    guard let newValue = newValue else { return }
                    loadTransferable(from: newValue)
                    isImageChanged = true // Mark the image as changed
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
                Button {
                    toggleEditMode()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(isEditindModeOn ? .red : .white)
                }
            }
        }
        .task {
            await profileVC.getInitialProfile()
            // Set the initial values once the profile is loaded
            initialUsername = profileVC.username
            initialEmail = profileVC.email
        }
        .onChange(of: editMode?.wrappedValue) { newValue in
            if let mode = newValue {
                if mode.isEditing {
                    // Entering edit mode: set initial values and enable fields
                    initialUsername = profileVC.username
                    initialEmail = profileVC.email
                    disableTextField = false
                } else {
                    // Exiting edit mode: disable fields and reset image change flag
                    disableTextField = true
                    isImageChanged = false // Reset image change flag
                }
                // Sync edit mode state
                isEditindModeOn = mode.isEditing
            }
        }
    }

    private func toggleEditMode() {
        isEditindModeOn.toggle()
        if isEditindModeOn {
            // Set initial values when entering edit mode
            initialUsername = profileVC.username
            initialEmail = profileVC.email
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
            } catch {
                debugPrint(error)
            }
        }
    }
}


