//
//  BaseAPI.swift
//  BIT Reminder
//
//  Created by Branislav Manojlovic on 8.9.23..
//

import Foundation
import Supabase

struct User {
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
    func signInWithEmailAndPassword(email: String, password: String, completion: @escaping (Error?) -> Void) async {
        do {
            _ = try await client.auth.signIn( email: email, password: password )
            completion(nil)
        } catch {
            debugPrint("error")
            completion(error)
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
