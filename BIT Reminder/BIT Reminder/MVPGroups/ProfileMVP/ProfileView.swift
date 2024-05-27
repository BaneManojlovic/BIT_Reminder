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
    @State private var isButtonDisabled = true
    @State private var initialUsername = ""
    
    
    var body: some View {
        ScrollView {
            VStack {
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
                    if isEditindModeOn == true {
                            PhotosPicker(selection: $imageSelection, matching: .images) {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .blur(radius: 1)
                            }
                        
                      
                    }
                }
                .background(Color("background_blue_color"))
                
                BaseCustomTextFieldView(text: $profileVC.username,
                                        placeholderText: "",
                                        isFormNotValid: $profileVC.isFormNotValid,
                                        fieldContentType: .nameInvalid,
                                        isInputValid: $profileVC.profileValidation, 
                                        isEditMode: isEditindModeOn)
                .foregroundStyle(.white)
                .disabled(disableTextField)
                
//                .onChange(of: initialUsername) { newValue in
//                    self.initialUsername = newValue
//                    
//                }
                .onChange(of: editMode?.wrappedValue) { newValue in
                    if (newValue != nil) && (newValue!.isEditing) {
                        disableTextField = false
                    } else {
                        disableTextField = true
                    }
                }
         
                
                
                BaseCustomTextFieldView(text: $profileVC.email,
                                        placeholderText: "",
                                        isFormNotValid: $profileVC.isFormNotValid,
                                        fieldContentType: .emailInvalid,
                                        isInputValid: $profileVC.profileValidation, 
                                        isEditMode: isEditindModeOn)
                
                .foregroundStyle(.white)
                .disabled(disableTextField)
                .onChange(of: editMode?.wrappedValue) { newValue in
                    if (newValue != nil) && (newValue!.isEditing) {
                        disableTextField = false
                    } else {
                        disableTextField = true
                    }
                }
                
                
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
                        
                        if isEditindModeOn == true {
                            Button(L10n.titleLabelUpdatePassword) {
                                profileVC.updateProfileButtonTapped()
                                DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            .disabled((profileVC.username.isEmpty || profileVC.username == initialUsername) || profileVC.email.isEmpty || profileVC.isFormNotValid)
                           // .disabled(isButtonDisabled)
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
                    guard let newValue else { return }
                    loadTransferable(from: newValue)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("background_blue_color"))
        }
        .background(Color("background_blue_color"))
        .navigationTitle(isEditindModeOn == true ? L10n.titleLabelEditProfile : L10n.titleLabelProfile)
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
                    isEditindModeOn.toggle()
                    disableTextField = false
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(isEditindModeOn == false ? .white : .red)
                }
            }
        }
        .task {
            await profileVC.getInitialProfile()
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
