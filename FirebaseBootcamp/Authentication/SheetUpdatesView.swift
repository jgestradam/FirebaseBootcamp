//
//  SheetUpdatesView.swift
//  FirebaseBootcamp
//
//  Created by Joseph Estrada on 3/17/23.
//

import SwiftUI

struct SheetUpdatesView: View {

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
                            .foregroundColor(.accentColor)
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

struct SheetUpdatesView_Previews: PreviewProvider {
    static var previews: some View {
        let randomModel = RandomModel(title: "Update Email", typeField: "New Email")
        SheetUpdatesView(selectedModel: randomModel)
    }
}
