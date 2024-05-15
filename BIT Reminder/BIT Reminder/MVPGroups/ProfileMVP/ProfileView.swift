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
    var authManager = AuthManager()
    
    @StateObject private var profileVC = ProfileViewModel()
    
    @State var isLoading = false
    @State var isEditindModeOn = false
    @State var disableTextField = true
    @State var imageSelection: PhotosPickerItem?
    @State private var showingAlert = false
    
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Group {
                        if let avatarImage = profileVC.avatarImage {
                            avatarImage.image.resizable()
                        } else {
                            Image(systemName: "person")
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
                        }
                    }
                }
            }
            .listRowBackground(Color.clear)
            
            Section {
                TextField("Username", text: $profileVC.username)
                    .disabled(disableTextField)
                    .onChange(of: editMode?.wrappedValue) { newValue in
                        if (newValue != nil) && (newValue!.isEditing) {
                            // Edit button tapped
                            disableTextField = false
                        } else {
                            // Done button tapped
                            disableTextField = true
                        }
                    }
                    .foregroundStyle(.white)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                TextField("Email", text: $profileVC.email)
                    .disabled(disableTextField)
                    .onChange(of: editMode?.wrappedValue) { newValue in
                        if (newValue != nil) && (newValue!.isEditing) {
                            // Edit button tapped
                            disableTextField = false
                        } else {
                            // Done button tapped
                            disableTextField = true
                        }
                    }
                    .foregroundStyle(.white)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            .listRowBackground(isEditindModeOn == false ? Color("tableview_cell_blue_color") : Color("textfield_blue_color") )
            Section {
                Button("Change Password") {
                    debugPrint("Change password")
                }
                .padding()
                .background(Color("textfield_blue_color"))
                .foregroundColor(Color.white)
                .clipShape(Capsule())
                
            }
            .listRowBackground(Color.clear)
            
            Section {
                Button("Delete account") {
                    showingAlert = true
                }
                .padding()
                .background(Color("textfield_blue_color"))
                .foregroundColor(Color.red)
                .clipShape(Capsule())
                
                .alert(isPresented:$showingAlert) {
                    Alert(
                        title: Text("Are you sure you want to delete this account?"),
                        message: Text(""),
                        primaryButton: .destructive(Text("Delete")) {
                            profileVC.deleteUser()
                            debugPrint("Deleting...")
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .listRowBackground(Color.clear)
        }
        
        .onChange(of: imageSelection) { newValue in
            guard let newValue else { return }
            loadTransferable(from: newValue)
        }
            .scrollContentBackground(.hidden)
            .background(Color("background_blue_color"))
            
        VStack {
            
            if isEditindModeOn == true {
                
                Button("Update Profile") {
                    profileVC.updateProfileButtonTapped()
                    DispatchQueue.main.asyncAfter(deadline: .now()+5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                .padding()
                .background(Color(red: 0, green: 0, blue: 0.5))
                .foregroundColor(Color.white)
                .clipShape(Capsule())
                
                if isLoading {
                    ProgressView()
                }
            }
        }
            .navigationTitle(isEditindModeOn == true ? "Edit Profile" : "Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isEditindModeOn = true
                        disableTextField = false
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundStyle(.white)
                    }
                }
                if isEditindModeOn == true {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isEditindModeOn = false
                            disableTextField = true
                        } label: {
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(.white)
                        }
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
