//
//  Home.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-23.
//

import SwiftUI

struct Home: View {
    let persistence = PersistenceController.shared
    var body: some View {
        TabView{
            Tab("Menu", systemImage: "list.dash") {
                Menu()
                .environment(\.managedObjectContext, persistence.container.viewContext)
            }
            Tab("Profile", systemImage: "square.and.pencil") {
                UserProfile()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
