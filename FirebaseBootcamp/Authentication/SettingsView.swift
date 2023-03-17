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

struct NewScreen: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    let selectedModel: RandomModel
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack {
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .padding()
                    }
                    Spacer()
                }
                
                Text(selectedModel.title)
                    .foregroundColor(Color.accentColor)
                    .font(.largeTitle)
                    .bold()
                
                if selectedModel.typeField == "New Email" {
                    
                    TextField("\(selectedModel.typeField)", text: $viewModel.newEmail)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.updateEmail()
                                print("Email Updated!")
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Reset")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                } else {
                    
                    SecureField("\(selectedModel.typeField)", text: $viewModel.newPassword)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.updatePassword()
                                print("Password Updated!")
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Reset")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(.ultraThinMaterial)
    }
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
            NewScreen(selectedModel: model)
        }
    }
}
