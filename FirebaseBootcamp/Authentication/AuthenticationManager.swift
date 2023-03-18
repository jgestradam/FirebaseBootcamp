//
//  AuthenticationManager.swift
//  FirebaseBootcamp
//
//  Created by Joseph Estrada on 3/15/23.
//

import Foundation
import FirebaseAuth

struct AuthDataResultsModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init () { }
    
    func getAuthenticatedUser() throws -> AuthDataResultsModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultsModel(user: user)
    }
    
    func getProvider() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        return providers
    }
        
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

// MARK: SIGN IN EMAIL

extension AuthenticationManager {
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultsModel {
        let authDataResults = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultsModel(user: authDataResults.user)
    }
    
    @discardableResult
    func signUser(email: String, password: String) async throws -> AuthDataResultsModel {
        let authDataResults = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultsModel(user: authDataResults.user)
    }
    
    func resetPasswor(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
}

// MARK: SIGN IN SSO

extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultsModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultsModel {
        let authDataResults = try await Auth.auth().signIn(with: credential)
        return AuthDataResultsModel(user: authDataResults.user)
    }
    
}
