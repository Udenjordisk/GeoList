//
//  Previews.swift
//  GeoList
//
//  Created by Кирилл on 23.09.2022.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        AddTaskView()
    }
}
