//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-23.
//

let kfirstName = "first name key"
let klastName = "last name key"
let kemail = "email key"
let kIsLoggedIn = "kIsLoggedIn"

import SwiftUI

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State private var showEmailValidAlert: Bool = false
    @State private var showEmptyField: Bool = false
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                
                Button("Register", action: {
                    if !(firstName.isEmpty) && !(lastName.isEmpty) && !(email.isEmpty) {
                        
                        if isEmail(valid: email) {
                            UserDefaults.standard.set(firstName, forKey: kfirstName)
                            UserDefaults.standard.set(lastName, forKey: klastName)
                            UserDefaults.standard.set(email, forKey: kemail)
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            isLoggedIn = true
                        }else {
                            showEmailValidAlert = true
                        }
                    }else {
                        showEmptyField = true
                    }
                })
                .buttonStyle(.bordered)
            }
            .padding(10)
            .alert("Email is invalid", isPresented: $showEmailValidAlert) {
                Button("OK", role: .cancel) { }
            }
            .alert("Empty Field!! Enter required value", isPresented: $showEmptyField) {
                Button("OK", role: .cancel) { }
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                Home()
            }
            .onAppear(perform: {
                if let userLoginStatus = UserDefaults.standard.value(forKey: "kIsLoggedIn") as? Bool {
                    if userLoginStatus {
                        isLoggedIn = true
                    }else {
                        isLoggedIn = false
                    }
                }else {
                    isLoggedIn = false
                }
            })
        }
    }
    
    // Function to validate email using regex
    func isEmail(valid: String) -> Bool {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: valid)
    }
}

#Preview {
    Onboarding()
}
