//
//  ToDo.swift
//  Checklist
//
//  Created by Samuel AYM on 19/07/23.
//

import Foundation
class ToDoModel : ObservableObject {
    @Published var itemArray = [Item]()
}
