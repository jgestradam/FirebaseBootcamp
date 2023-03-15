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
    
    init (user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
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
    
    func createUser(email: String, password: String) async throws -> AuthDataResultsModel {
        let authDataResults = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultsModel(user: authDataResults.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
