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
                        
                        LittleLemonButton(
                            buttonTitle: "Change",
                            buttonAction: {
                            showSheet = true
                        },
                            buttonType: .primary,
                            buttonState: .active)
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
                        LittleLemonButton(
                            buttonTitle: "Discard Changes",
                            buttonAction: {
                                updateChanges(isDiscard: true)
                        },
                            buttonType: .secondary,
                            buttonState: .inactive
                        )
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("primaryColor"), lineWidth: 1.0)
                        )
                        
                        LittleLemonButton(
                            buttonTitle: "Save Changes",
                            buttonAction: {
                                updateChanges(isDiscard: false)
                                isChangesSaved = true
                        },
                            buttonType: .primary,
                            buttonState: .active
                        )
                    }
                    Spacer()
                    LittleLemonButton(
                        buttonTitle: "Log Out",
                        buttonAction: {
                            UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                            path = []
                    },
                        buttonType: .secondary,
                        buttonState: .active
                    )
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
