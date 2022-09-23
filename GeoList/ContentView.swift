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
    
    @StateObject private var locationManager = LocationManager()

    private var coordinates: CLLocationCoordinate2D?  {
        guard let coordinates = locationManager.location?.coordinate else {
            return nil
        }
        return coordinates
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lists.name, ascending: true)],
        animation: .default)
    var lists: FetchedResults<Lists>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.name, ascending: true)],
        animation: .default)
    var tasks: FetchedResults<Tasks>
    
    @State private var selectedListIndex = 0
    @State private var selectedHostList = "Общие дела"
//    @State private var location = ""
    
    var body: some View {
        NavigationView {
            ZStack{
                
                //checkLocation()
                
                List {
                    ForEach(tasks) { task in
                        
                        //FIXME: incorrect display on list "Дом"
                        if task.hostList == selectedHostList {
                            NavigationLink{
                                Text(task.name ?? "Нет значения")
                                Text(task.hostList!)
                            } label: {
                                Text(task.name ?? "Нет значения")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                
                
                VStack{
                    
//                    if let coordinates = coordinates {
//                        Text(String(coordinates.latitude))
//                    }
//
                    
                    Spacer()
                    
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
            .navigationTitle(selectedHostList).onAppear(perform: {
                checkLocation()
            })
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
    
    private func checkLocation() -> some View{
        //If we have permission to check location
        if let coordinates = coordinates {
            
            for list in lists{
                
                if list.latitude == coordinates.latitude && list.longitude == coordinates.longitude {
                    selectedHostList = list.name!
                }
                
            }
        }
        
        return EmptyView()
    }
    
 
    
    
}

//
//struct LaunchScreenView: View{
//
//
//    var body: some View{
//        Text("Loading...\nPlease wait")
//            .onAppear{
//                sleep(3)
//
//            }
//
//    }
//
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        AddTaskView()
    }
}


