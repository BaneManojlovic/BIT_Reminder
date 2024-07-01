//
//  ProfileViewModel.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.5.24..
//

import Foundation
import SupabaseStorage
import UIKit
import KRProgressHUD

// swiftlint: disable trailing_whitespace vertical_whitespace
class ProfileViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var email = ""
    @Published var avatarImage: AvatarImage?
    @Published var isFormNotValid = true
    @Published var profileValidation: [ValidationError: Bool] = [.nameInvalid: false, .emailInvalid: false]
    init() {

    }
    var isLoading = false
    var authManager = AuthManager()
    let userDefaults = UserDefaultsHelper()

    
    func getInitialProfile() async {
        do {
            
            let currentUser = try await authManager.client.auth.session.user
            
            let profile: UserModel = try await authManager.client.database
            
                .from("profiles")
                .select()
                .eq(column: "id", value: currentUser.id)
                .single()
                .execute()
                .value
            await MainActor.run {
                self.username = profile.userName ?? ""
                self.email = profile.userEmail
            }
            
            if let avatarURL = profile.avatarURL, !avatarURL.isEmpty {
                try await downloadImage(path: avatarURL)
            }
        } catch {
            debugPrint(error)
        }
    }
    private func downloadImage(path: String) async throws {
          let data = try await authManager.client.storage.from(id: "avatars").download(path: path)
        avatarImage = AvatarImage(data: data)
      }
    
    func updateProfileButtonTapped() {
        KRProgressHUD.show()
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                let imageURL = try await uploadImage()
                
                let currentUser = try await authManager.client.auth.session.user
                
                let updatedProfile = UserModel(
                    profileId: currentUser.id.uuidString,
                    userName: username,
                    userEmail: email,
                    avatarURL: imageURL
                )
                
                try await authManager.client.database
                    .from("profiles")
                    .update(values: updatedProfile)
                    .eq(column: "id", value: currentUser.id)
                    .execute()
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    KRProgressHUD.dismiss()
                }
            } catch {
                KRProgressHUD.dismiss()
                debugPrint("Error updating profile: \(error)")
            }
        }
    }
    
    private func uploadImage() async throws -> String? {
        guard let data = avatarImage?.data else { return nil }
        
        let filePath = "\(UUID().uuidString).jpeg"
        try await authManager.client.storage
            .from(id: "avatars")
            .upload(
                path: filePath,
                file: File(name: "avatar_url", data: data, fileName: "avatar_url.jpeg", contentType: ".jpeg"),
                fileOptions: FileOptions(cacheControl: "3600")
            )
        
        return filePath
    }
    
    func deleteUser() {
        Task {
            do {
                try await self.authManager.deleteUserAccount { error in
                    if let error = error {
                       debugPrint(error)
                    } else {
                        self.userDefaults.removeUser()
                        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                            self.goToSplashScreen()
                        }
                    }
                }
            }
        }
    }
    func goToSplashScreen() {
        guard let app = UIApplication.shared.delegate as? AppDelegate,
        let window = app.window else { return }

        let splashVC = StoryboardScene.Authentification.splashScreenViewController.instantiate()

        window.switchRootViewController(splashVC)
    }
}

