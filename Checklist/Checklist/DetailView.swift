//
//  DetailView.swift
//  Checklist
//
//  Created by Samuel AYM on 19/07/23.
//

import SwiftUI

struct DetailView: View {
    
    var taskTitle : String = "Testing"
    var dateCreated : Date = Date()
    var dueDate : Date = Date()
    var taskID : Int16 = 0
    var isDone : Bool = false
    var indexPath : Int = 0
    var timeFinished : Date?
    var body: some View {
        List{
            Text(taskTitle)
                .bold()
                .font(.title)
                .padding(.vertical)
            HStack{
                Text("Due Date : ")
                Text("\(dueDate, formatter: itemFormatter)")
            }
            HStack{
                Text("Time Created : ")
                Text("\(dateCreated, formatter: itemFormatter)")
            }
            HStack{
                Text("Time Finished : ")
                if let safeTime = timeFinished{
                    Text("\(safeTime, formatter: itemFormatter)")
                } else {
                    Text("None")
                }

            }
            
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()
