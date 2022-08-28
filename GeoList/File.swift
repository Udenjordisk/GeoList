//
//  File.swift
//  GeoList
//
//  Created by Кирилл on 28.08.2022.

import SwiftUI

struct mainView: View{
var body: some View {
    NavigationView {
        List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text(item.val ?? "Нет значения")
//                    } label: {
//                        Text(item.val ?? "")
//                    }
//                }
//                .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
            NavigationLink {
//                    AddTaskView()
            } label: {
                Image(systemName: "plus.circle")
            }
            }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
        }
        Text("Select an item")
    }
    .navigationTitle("Задачи")
}
}
