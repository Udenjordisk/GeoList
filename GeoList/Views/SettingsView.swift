//
//  SettingsView.swift
//  GeoList
//
//  Created by Кирилл on 23.09.2022.
//

import SwiftUI
import CoreData
import MapKit

struct SettingsView: View{
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lists.name, ascending: true)],
        animation: .default)
var lists: FetchedResults<Lists>
    
    var body: some View{
        VStack{
            List {
                ForEach(lists) { list in
                    //All lists
                        NavigationLink{
                            //TODO: Maybe list settings(geo, name)
                            //Text(list.name ?? "Нет значения")
                            } label: {
                            Text(list.name ?? "Нет значения")
                            }
                        }
                    .onDelete(perform: deleteItems)
                }
            .navigationTitle("Мои списки")
        }
    }
    //Delete from list
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { lists[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
