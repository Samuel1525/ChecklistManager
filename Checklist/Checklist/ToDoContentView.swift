//
//  ContentView.swift
//  Checklist
//
//  Created by Samuel AYM on 19/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var toDoVM : ToDoModel
    
    @State private var showingSheet = false
    
    @State var taskArray = [Item]()

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    VStack{
                        NavigationLink {
                            DetailView(taskTitle: item.title ?? "None", dateCreated: item.timestamp ?? Date() , dueDate: item.dueDate ?? Date(), taskID: item.id , isDone: item.done
                                       ,timeFinished: item.timeFinished)
                        }
                    label: {
                        HStack{
                            Image(systemName:
                                    item.done ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: item.done ? 25 : 20))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.5))
                                        {
                                            toggleDone(item : item)
                                        }
                                    

                                }
                                .frame(width: 25, alignment: .center)
                                .foregroundColor(item.done ? .green : .black)
                            VStack(alignment: .leading){
                                Text(item.title ?? "None")
                                    .font(.headline)
                                Text(" \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                Text(item.note ?? "None")
                                    .font(.footnote)
                                    .opacity(0.7)
                                }
                            }
                        
                            
                        }
                       
                    }

                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }.sheet(isPresented: $showingSheet) {
                        AddItem()
                        
                    }

//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
                }
            }
            Text("Select an item")
        }
        .onAppear(perform: loadItem)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.done = false
            newItem.title = "testing" + String(items.count)
            newItem.id = Int16(items.count)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func loadItem(){
        taskArray = Array(items)
        toDoVM.itemArray = Array(items)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func toggleDone(item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].done.toggle()
            if items[index].done == true {
                items[index].timeFinished = Date()
            } else {
                items[index].timeFinished = nil
            }
            
            loadItem()
        }
        saveItems()
    }
    func saveItems(){
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
