//
//  BaseAPI.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import Foundation
import Supabase
import SupabaseStorage

class AuthManager {

    static let shared = AuthManager()
    let userDefaults = UserDefaultsHelper()

    /// unique projecturl from supabase
    static let projectUrl = URL(string: Constants.baseURL)!
    /// unique api key from supabase
    static let apiKey = Constants.baseApiKey

    let client = SupabaseClient(supabaseURL: projectUrl, supabaseKey: apiKey)

    init() {}

    /// API method for SingIn using email & password
    func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (Error?, Session?) -> Void) async {
        do {
            let data = try await client.auth.signIn(email: email, password: password )
            if ((data as? Session) != nil) {
                debugPrint("Session je = \(data)")
                completion(nil, data)
            }
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }

    /// API method for Register new user using email & password
    func registerNewUserWithEmailAndPassword(email: String, password: String, completion: @escaping (Error?, Session?) -> Void) async {
        do {
            let data = try await client.auth.signUp(email: email, password: password)
            if let session = data.session {
                completion(nil, session)
            } else {
                debugPrint("error - session = nil")
            }
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }

    /// API method for saving user to users table in database
    func saveUser(user: UserModel, completion: @escaping (Error?) -> Void) async {
        do {
            try await client.database.from("users").insert(values: user).execute()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func getUserData(completion: @escaping (Error?, [UserModel]?) -> Void) async {
        guard let user = self.userDefaults.getUser() else { return }
        do {
            let response: [UserModel] = try await client.database.from("users").select().eq(column: "profileId", value: user.profileId).execute().value
            completion(nil, response)
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }

    /// API method for check is current User in database
    func retrieveUser(completion: @escaping (Error?, Any?) -> Void) async {
        do {
            let data = try await client.auth.session.user
            completion(nil, data)
        } catch {
            completion(error, nil)
        }
    }

    /// API method for LogIn user form supabase database
    func userLogout(completion: @escaping (Error?) -> Void) async {
        do {
            try await client.auth.signOut()
            completion(nil)
        } catch {
            debugPrint("error")
            completion(error)
        }
    }

    // MARK: - Reminder API Data Methods

    func getReminders(completion: @escaping (Error?, [Reminder]?) -> Void) async {
        guard let user = self.userDefaults.getUser() else { return }
        do {
            let reminders: [Reminder] = try await client.database.from("reminders").select().eq(column: "profileId", value: user.profileId).execute().value
            completion(nil, reminders)
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }

    func addNewReminder(model: Reminder, completion: @escaping (Error?, PostgrestResponse<Void>?) -> Void) async {
        do {
            let response = try await client.database.from("reminders").insert(values: model).execute()
            completion(nil, response)
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }

    func deleteReminder(tableName: String, model: Reminder, completion: @escaping (Error?) -> Void) async {
        if let modelId = model.id {
            do {
                let response = try await client.database.from("reminders").delete().eq(column: "id", value: modelId).execute()
                completion(nil)
            } catch {
                debugPrint("error")
                completion(error)
            }
        }
    }

    // MARK: - Albums API Data Methods

    func getAlbums(completion: @escaping (Error?, [Album]?) -> Void) async {
        guard let user = self.userDefaults.getUser() else { return }
        do {
            let albums: [Album] = try await client.database.from("albums").select().eq(column: "profileId", value: user.profileId).execute().value
            completion(nil, albums)
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }

    func createNewAlbum(album: Album, completion: @escaping (Error?) -> Void) async {
        do {
            try await client.database.from("albums").insert(values: album).execute()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func deleteAlbum(modelID: Int, completion: @escaping (Error?) -> Void) async {
        do {
            let response = try await client.database.from("albums").delete().eq(column: "id", value: modelID).execute()
            completion(nil)
        } catch {
            debugPrint("error")
            completion(error)
        }
    }

    func getPhotos(albumId: Int, completion: @escaping (Error?, [Photo]?) -> Void) async {
        do {
            let photos: [Photo] = try await client.database.from("photos").select().eq(column: "albumId", value: "\(albumId)").execute().value
            completion(nil, photos)
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }
    // TODO: - finish this...
    func uploadPhoto(imageData: Data, completion: @escaping (Error?, URL?) -> Void) async {
        // TODO: - Add random number generator to add unique name to images
        var uniqueNumber = Int.random(in: 1...99999)
        let file = File(name: "picture", data: imageData, fileName: "picture.jpeg", contentType: "image/jpeg")
        do {
            try await client.storage.from(id: "photos").upload(path: "picture\(uniqueNumber).jpeg", file: file, fileOptions: FileOptions(cacheControl: "3600"))
            let imageURL = try client.storage.from(id: "photos").getPublicURL(path: "picture\(uniqueNumber).jpeg")
            completion(nil, imageURL)
        } catch {
            debugPrint("error")
            completion(error, nil)
        }
    }
    
    func savePhotoToDatabase(model: Photo, completion: @escaping (Error?) -> Void) async {
        do {
            try await client.database.from("photos").insert(values: model).execute()
            completion(nil)
        } catch {
            completion(error)
        }
    }
}
/*
 func saveUser(user: UserModel, completion: @escaping (Error?) -> Void) async {
     do {
         try await client.database.from("users").insert(values: user).execute()
         completion(nil)
     } catch {
         completion(error)
     }
 }
 */
