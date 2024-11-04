//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-24.
//

import SwiftUI
import PhotosUI

struct UserProfile: View {
    var firstName: String = UserDefaults.standard.string(forKey: "first name key") ?? ""
    var lastName: String = UserDefaults.standard.string(forKey: "last name key") ?? ""
    var email: String = UserDefaults.standard.string(forKey: "email key") ?? ""
    @State var updatedFirstName = ""
    @State var updatedLastName = ""
    @State var updatedEmail = ""
    @State var isChangesSaved: Bool = false
    @State private var showSheet = false
    @State var profileImage = UIImage(named: "profile-image-placeholder")
    @Binding var path: [String]

    var body: some View {
        
        VStack(spacing: 20){
            Image("little-lemon-header")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            ScrollView{
                VStack(alignment: .leading, spacing: 20){
                    Text("Personal Information")
                    HStack(spacing: 20){
                        Image(uiImage: profileImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:120, height: 120)
                            .clipShape(.circle)
                        
                        Button("Change", action: {
                            showSheet = true
                        })
                        .padding()
                        .frame(width: 100, height: 40)
                        .background(Color("primaryColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading){
                        Text("First Name")
                            .font(.caption)
                            .fontWeight(.medium)
                        TextField(firstName, text: $updatedFirstName)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading){
                        Text("Last Name")
                            .font(.caption)
                            .fontWeight(.medium)
                        TextField(lastName, text: $updatedLastName)
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack(alignment: .leading){
                        Text("Email")
                            .font(.caption)
                            .fontWeight(.medium)
                        TextField(email, text: $updatedEmail)
                            .textFieldStyle(.roundedBorder)
                    }
                    Spacer()
                    HStack(spacing: 20){
                        Button("Discard Changes", action: {
                            updateChanges(isDiscard: true)
                        })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("primaryColor"), lineWidth: 1.0)
                        )
                        
                        Button("Save Changes", action: {
                            updateChanges(isDiscard: false)
                            isChangesSaved = true
                        })
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("primaryColor"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    Spacer()
                    Button("Log Out", action: {
                        UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                        path = []
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("secondaryColor"))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $showSheet) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$profileImage)
                }
                .alert("Changes saved successfully!", isPresented: $isChangesSaved) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
        .padding()
    }
    
    func updateChanges(isDiscard:Bool = false){
        UserDefaults.standard.set(isDiscard ? firstName : (updatedFirstName.isEmpty ? firstName : updatedFirstName), forKey: kfirstName)
        UserDefaults.standard.set(isDiscard ? lastName : (updatedLastName.isEmpty ? lastName : updatedLastName), forKey: klastName)
        UserDefaults.standard.set(isDiscard ? email : (updatedEmail.isEmpty ? email : updatedEmail), forKey: kemail)
    }
}

#Preview {
    UserProfile(path: .constant([]))
}
