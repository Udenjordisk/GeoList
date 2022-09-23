//
//  AddListView.swift
//  GeoList
//
//  Created by Кирилл on 23.09.2022.
//

import SwiftUI
import CoreData
import MapKit

struct AddListView: View{
    
    
    @Environment(\.managedObjectContext)  var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Lists.name, ascending: true)],
        animation: .default)
     var lists: FetchedResults<Lists>
    
    @StateObject private var locationManager = LocationManager()

    private var coordinates: CLLocationCoordinate2D?  {
        guard let coordinates = locationManager.location?.coordinate else {
            return nil
        }
        return coordinates
    }
    
    
    
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
            if addGeo {
               
                newList.latitude = coordinates!.latitude
                newList.longitude = coordinates!.longitude
                newList.useGeoposition = true
                print(newList.longitude, newList.latitude)



                
            }
            
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
