//
//  ContentView.swift
//  GeoList
//
//  Created by Кирилл on 28.08.2022.
//

import SwiftUI
import CoreData
import MapKit



//MARK: Main View
struct ContentView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lists.name, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<Lists>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.name, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Tasks>
    
    @State private var selectedListIndex = 0
    @State private var selectedHostList = "Общие дела"
    
    @StateObject private var locationManager = LocationManager()
    
    private var coordinates: CLLocationCoordinate2D?  {
        guard let coordinates = locationManager.location?.coordinate else {
            return nil
        }
        return coordinates
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                
                //checkLocation()
                
                List {
                    ForEach(tasks) { task in
                        //FIXME: incorrect display on list "Дом"
                        //Tasks for selected list
                        if task.hostList == selectedHostList {
                            NavigationLink{
                                //TODO: Link to detail description
                                Text(task.name ?? "Нет значения")
                                Text(task.hostList!)
                            } label: {
                                //Task name
                                Text(task.name ?? "Нет значения")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                VStack{
//
//            if let coordinates = coordinates {
//                Text(String(coordinates.latitude))
//            }
                    
                    Spacer()
                    
                    //Add task button
                    NavigationLink {
                        AddTaskView()
                    } label: {
                        HStack{
                            Image(systemName: "plus.app")
                            Text("Новая задача")
                                .bold()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue, in: Capsule())
                    }
                }
            }
            //Select current list as navigation title
            .navigationTitle(selectedHostList).onAppear(perform: {
                // checkLocation()
            })
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    //Select lists picker
                    Picker(selection: $selectedListIndex) {
                        ForEach((0...lists.count - 1), id: \.self) { index in
                            Text(lists[index].name!)
                                .bold()
                        }
                    } label: {Text("") }
                        .padding()
                        .onChange(of: selectedListIndex, perform: { value in
                            selectedHostList = lists[value].name!
                        })
                }
                ToolbarItem(placement: .navigationBarLeading){
                    //Settings button
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
        Text("Select an item")
    }
        .navigationViewStyle(.stack)
}
    
    //Delete from CoreData
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    
    //If among the sheets there is one that is in the current coordinates.
    private func checkLocation() -> some View{
        //If we have permission to check location
        if let coordinates = coordinates {
            //Check all lists
            for list in lists{
                //Check coordinates
                if list.latitude == coordinates.latitude && list.longitude == coordinates.longitude {
                    //Select this list
                    selectedHostList = list.name!
                }
            }
        }
        //Func must return some View
        return EmptyView()
    }
}




