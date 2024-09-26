//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-24.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.dismiss) var dismiss
    var firstName: String = UserDefaults.standard.string(forKey: "first name key") ?? ""
    var lastName: String = UserDefaults.standard.string(forKey: "last name key") ?? ""
    var email: String = UserDefaults.standard.string(forKey: "email key") ?? ""
    
    var body: some View {
        VStack(spacing: 20){
            Text("Personal Information")
            Image("profile-image-placeholder")
                .resizable()
                .scaledToFit()
                .frame(width:120, height: 120)
                .clipShape(.circle)
            Text(firstName)
            Text(lastName)
            Text(email)
            Button("Logout", action: {
                UserDefaults.standard.set(false, forKey: "kIsLoggedIn")
                dismiss()
            })
            .buttonStyle(.bordered)
            Spacer()
        }
    }
}

#Preview {
    UserProfile()
}
