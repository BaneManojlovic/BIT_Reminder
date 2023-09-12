//
//  BaseAPI.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import Foundation
import Supabase

struct User: Codable {
    let uid: String
    let email: String?
}

class AuthManager {

    static let shared = AuthManager()

    /// unique projecturl from supabase
    static let projectUrl = URL(string: "https://oyiekaudpdofwfnabsqa.supabase.co")!
    /// unique api key from supabase
    static let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95aWVrYXVkcGRvZndmbmFic3FhIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTQxNjY3NDksImV4cCI6MjAwOTc0Mjc0OX0.LsiROrdeoROe5m9Gaz6TD8fO0cYSRyXONYYTAhgfQhg"

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
                debugPrint("Session je = \(session)")
                debugPrint("User je = \(session.user)")
                completion(nil, session)
            } else {
                debugPrint("error - session = nil")
            }
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
}
