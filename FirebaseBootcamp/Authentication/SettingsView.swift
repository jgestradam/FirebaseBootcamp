//
//  SettingsView.swift
//  FirebaseBootcamp
//
//  Created by Joseph Estrada on 3/15/23.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var newEmail = ""
    @Published var newPassword = ""
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPasswor(email: email)
    }
    
    func updateEmail() async throws {
        try await AuthenticationManager.shared.updateEmail(email: newEmail)
    }
    
    func updatePassword() async throws {
        try await AuthenticationManager.shared.updatePassword(password: newPassword)
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    @State var selectedModel: RandomModel? = nil
    
    var body: some View {
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            emailSection
            
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(showSignInView: .constant(false))
        }
    }
}

struct RandomModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    var typeField: String
}


extension SettingsView {
    private var emailSection: some View {
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password Reset!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Update Email") {
                selectedModel = RandomModel(title: "Update Email", typeField: "New Email")
            }
            
            Button("Update Password") {
                selectedModel = RandomModel(title: "Update Password", typeField: "New Password")
            }
            
        } header: {
            Text("Email functions")
        }
        .sheet(item: $selectedModel) { model in
            SheetUpdatesView(selectedModel: model)
        }
    }
}
