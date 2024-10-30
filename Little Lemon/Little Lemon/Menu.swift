//
//  Menu.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-23.
//

import SwiftUI
import CoreData


struct Menu: View {
    
    enum highlightTag {
        case all
        case starters
        case mains
        case desserts
        case drinks
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var path: [String]
    @State var searchText = ""
    @State var categoryType = ""
    @State private var highlighted = highlightTag.all
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Spacer()
                Image("little-lemon-header")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Spacer()
                NavigationLink(destination: UserProfile(path: $path)) {
                    Image("profile-image-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:50, height: 50)
                        .clipShape(.circle)
                }
            }
            VStack(alignment: .leading) {
                Text("Little Lemon")
                    .font(.title)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundStyle(Color("secondaryColor"))
                Text("Chicago")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(Color.white)
                HStack {
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .font(.callout)
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.white)
                    
                    Image("onboarding_img")
                        .presentationCornerRadius(4.0)
                        .frame(width: 150, height: 180)
                }
                TextField("Search menu", text: $searchText)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color("primaryColor"))
            
            VStack(alignment:.leading, spacing: 20){
                Text("ORDER FOR DELIVERY!")
                    .font(.headline)
                    .fontWeight(.medium)
                ScrollView(.horizontal, showsIndicators: true){
                    HStack(alignment:.center, spacing: 25){
                        Button(action: {
                            categoryType = ""
                            highlighted = .all
                        }, label: {
                            Text("All")
                        })
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(highlighted == .all ? Color.white : Color("primaryColor"))
                        .background(Color("primaryColor").opacity(highlighted == .all ? 1.0 : 0.1))
                        .clipShape(.capsule)
                        
                        Button(action: {
                            categoryType = "starters"
                            highlighted = .starters
                        }, label: {
                            Text("Starters")
                        })
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(highlighted == .starters ? Color.white : Color("primaryColor"))
                        .background(Color("primaryColor").opacity(highlighted == .starters ? 1.0 : 0.1))
                        .clipShape(.capsule)
                        
                        Button(action: {
                            categoryType = "mains"
                            highlighted = .mains
                        }, label: {
                            Text("Mains")
                        })
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(highlighted == .mains ? Color.white : Color("primaryColor"))
                        .background(Color("primaryColor").opacity(highlighted == .mains ? 1.0 : 0.1))
                        .clipShape(.capsule)
                        
                        Button(action: {
                            categoryType = "desserts"
                            highlighted = .desserts
                        }, label: {
                            Text("Dessert")
                        })
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(highlighted == .desserts ? Color.white : Color("primaryColor"))
                        .background(Color("primaryColor").opacity(highlighted == .desserts ? 1.0 : 0.1))
                        .clipShape(.capsule)
                        
                        Button(action: {
                            categoryType = "drinks"
                            highlighted = .drinks
                        }, label: {
                            Text("Drinks")
                        })
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(highlighted == .drinks ? Color.white : Color("primaryColor"))
                        .background(Color("primaryColor").opacity(highlighted == .drinks ? 1.0 : 0.1))
                        .clipShape(.capsule)
                        
                    }
                    .frame(maxWidth:.infinity)
                }
                .frame(maxWidth:.infinity)
            }
            FetchedObjects(
                predicate:buildPredicate(),
                sortDescriptors: buildSortDescriptors())
            { (menuItems: [Dish]) in
                if menuItems.count > 0 {
                    let filteredItems = removeDuplicateDishes(from: menuItems)
                    List {
                        ForEach(filteredItems, id:\.self) { item in
                            HStack(alignment: .center){
                                VStack(alignment: .leading, spacing: 10){
                                    Text(item.title!)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                    Text(item.itemDescription!)
                                        .fontWeight(.thin)
                                    Text("$\(item.price!)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color("primaryColor"))
                                }
                                Spacer()
                                AsyncImage(url: URL(string: item.image!)) { image in
                                    image.image?.resizable()
                                }
                                .frame(width: 60, height: 60)
                            }
                        }
                    }
                }else {
                    VStack{
                        Spacer()
                        Text("No Data Found!")
                            .font(.headline)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .padding(20)
        .onAppear(perform: {
            getMenuData()
        })
    }
    
    func getMenuData(){
        PersistenceController.shared.clear()
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                let fullMenu = try! decoder.decode(MenuList.self, from: data)
                let menuItems = fullMenu.menu
                
                for item in menuItems {
                    let dish = Dish(context: viewContext)
                    dish.title = item.title
                    dish.price = item.price
                    dish.itemDescription = item.description
                    dish.image = item.image
                    dish.id = Int32(item.id)
                    dish.category = item.category
                }
                
                try? viewContext.save()
            }
        })
        dataTask.resume()
    }
    
    private func removeDuplicateDishes(from dishes: [Dish]) -> [Dish]{
        var seenNames = Set<String>()
        return dishes.filter { dish in
            guard let name = dish.title else { return false }
            return seenNames.insert(name).inserted
        }
    }
    
    func buildPredicate() -> NSPredicate {
        return searchText == "" ? (categoryType == "" ? (NSPredicate(value: true)) : (NSPredicate(format: "category CONTAINS[cd] %@", categoryType))) : NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
}

#Preview {
    Menu(path: .constant([]))
}
