//
//  Menu.swift
//  Little Lemon
//
//  Created by Garima Bhala on 2024-09-23.
//

import SwiftUI
import CoreData


struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        entity: Dish.entity(),
//        sortDescriptors: [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))],
//        predicate: NSPredicate(format: "title CONTAINS[cd] %@", "pie"),
//        animation: .default)
//    var menuItems: FetchedResults<Dish>
    @State var searchText = ""
    var body: some View {
        VStack(spacing: 20){
            Text("Little Lemon")
                .font(.title)
                .fontWeight(.medium)
            Text("Chicago")
                .font(.title2)
            Text("Little Lemon is food ordering app that allows you to order food online.")
                .font(.title3)
            TextField("Search menu", text: $searchText)
            FetchedObjects(
                predicate:buildPredicate(),
                sortDescriptors: buildSortDescriptors())
            { (menuItems: [Dish]) in
                
                List {
                    ForEach(menuItems, id:\.self) { item in
                        HStack(alignment: .center){
                            VStack(alignment: .leading, spacing: 10){
                                Text("Dish: \(item.title!)")
                                Text("Price: $\(item.price!)")
                            }
                            Spacer()
                            AsyncImage(url: URL(string: item.image!)) { image in
                                image.image?.resizable()
                            }
                            .frame(width: 60, height: 60)
                        }
                    }
                }
            }
        }
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
    
    func buildPredicate() -> NSPredicate {
        return searchText == "" ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedStandardCompare))]
    }
}

#Preview {
    Menu()
}
