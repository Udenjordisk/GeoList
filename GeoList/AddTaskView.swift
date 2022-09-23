//
//  AddTaskView.swift
//  GeoList
//
//  Created by Кирилл on 23.09.2022.
//

import SwiftUI
import CoreData
import MapKit


struct AddTaskView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lists.name, ascending: true)],
        animation: .default)
    var lists: FetchedResults<Lists>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.name, ascending: true)],
        animation: .default)
    var tasks: FetchedResults<Tasks>
    
    
    @State private var taskName = ""
    @State private var selectedListIndex = 0
    @State private var selectedListName = ""
    
    var body: some View{
        
        VStack{
            
            HStack{
            NavigationLink {
                AddListView()
            } label: {
                HStack{
                    Image(systemName: "plus")
                    Image(systemName: "doc")
                    Text("Новый список")
                }
            }
            .padding()
                
                Spacer()
                
                Picker(selection: $selectedListIndex) {
                    ForEach((0...lists.count - 1), id: \.self) { index in
                        Text(lists[index].name!)
                    }
                } label: {Text("") }
                .padding()
                .onChange(of: selectedListIndex, perform: { value in
                            
                    selectedListName = lists[value].name!
                    print(selectedListName)
                        })
                
                
                
                
            }
            
            Spacer()
            
            Image(systemName: "book.circle.fill")
                .resizable()
                .frame(width: 150.0, height: 150.0)
                .opacity(0.1)
                Text("«Любую задачу реально выполнить,\nесли разбить ее на выполнимые части.»")
                .foregroundColor(Color.secondary)
            
            TextField("Например: Купить продукты",text: $taskName)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Button {
                addTask()
            } label: {
                HStack{
                    Image(systemName: "plus.app")
                    Text("Добавить задачу")
                        .bold()
                }
                .padding()
                .foregroundColor(.white)
                .background(.blue, in: Capsule())
            }
            
            Spacer()
            
        }
        .navigationTitle("Добавить задачу")
    }
    
    private func addTask() {
        withAnimation {
            
            guard taskName != "" else { return }
            
            let newTask = Tasks(context: viewContext)
            newTask.name = taskName
            
            if selectedListName !=  "" {
            newTask.hostList = selectedListName
            } else {
                newTask.hostList = "Общие задачи"
            }
            taskName = ""
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
