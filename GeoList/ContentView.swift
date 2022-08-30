//
//  ContentView.swift
//  GeoList
//
//  Created by Кирилл on 28.08.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
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
    @State private var selectedHostList = "Дом"
    
    
    var body: some View {
        NavigationView {
            ZStack{
                
                
                
                List {
                    ForEach(tasks) { task in
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
            .navigationTitle(selectedHostList)
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
}

struct SettingsView: View{
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lists.name, ascending: true)],
        animation: .default)
    var lists: FetchedResults<Lists>
    
    var body: some View{
        
        List {
            ForEach(lists) { list in
                
                    NavigationLink{
                        Text(list.name ?? "Нет значения")
                    } label: {
                        Text(list.name ?? "Нет значения")
                    }
                
            }
            .onDelete(perform: deleteItems)
        }
       
       
            .navigationTitle("Мои списки")
    }
    
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


struct AddListView: View{
    
    
    @Environment(\.managedObjectContext)  var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lists.name, ascending: true)],
        animation: .default)
     var lists: FetchedResults<Lists>
    
    
    @State var listName: String = ""
    @State var addGeo: Bool = false

    var body: some View{
        VStack{
            VStack{
            Image(systemName: "doc.circle.fill")
                .resizable()
                .frame(width: 150.0, height: 150.0)
                .opacity(0.1)
                Text("«Думайте на бумаге. Каждая минута, затраченная на планирование,\nэкономит 10 минут при осуществлении плана.»")
                    .foregroundColor(Color.secondary)
                    .padding()
            }
        TextField("Например: тренажёрный зал",text: $listName)
                .textFieldStyle(.roundedBorder)
                .padding()
            Toggle("Использовать геопозицию", isOn: $addGeo)
                .padding()
            
            Button {
                addList()
            } label: {
                HStack{
                    Image(systemName: "plus.app")
                    Text("Добавить список")
                        .bold()
                }
                .padding()
                .foregroundColor(.white)
                .background(.blue, in: Capsule())
            }
            .padding()



        }.navigationTitle("Новый список")
    }
    
    private func addList () {
        withAnimation {
            
            guard listName != "" else { return }
            
            let newList = Lists(context: viewContext)
            newList.name = listName
            listName = ""
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        AddTaskView()
    }
}
