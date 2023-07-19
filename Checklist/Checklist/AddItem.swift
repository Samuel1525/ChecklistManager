//
//  AddItem.swift
//  Checklist
//
//  Created by Samuel AYM on 19/07/23.
//

import SwiftUI

struct AddItem: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var taskName = ""
    @State private var dueDate = Date.now + (60*60*24)
    @State private var note = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    VStack {
                        Text("Add New Task")
                            .bold()
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .listRowSeparator(.hidden)
                    
                    VStack(alignment: .leading) {
                        Divider()
                        TextField("Enter task name", text: $taskName)
                        Divider().padding(.bottom)
                        DatePicker("Due Date", selection: $dueDate).padding(.bottom)
                        Divider()
                        
                        TextField("Notes", text: $note, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding(.top)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Perform save action here
                        addItem()
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    func addItem(){
        let newItem = Item(context: viewContext)
        newItem.title = taskName
        newItem.dueDate = dueDate
        newItem.done = false
        newItem.timestamp = Date()
        newItem.id = Int16(items.count)
        newItem.note = note
        newItem.timeFinished = nil
        saveItem()
    }
    
    func saveItem(){
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



struct AddItem_Previews: PreviewProvider {
    static var previews: some View {
        AddItem()
    }
}
