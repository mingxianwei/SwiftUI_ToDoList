//
//  ToDoItem.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/10/28.
//

import SwiftUI


class Todo: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(self.tittle, forKey: "tittle")
        coder.encode(self.dudate, forKey: "dudate")
        coder.encode(self.checked,forKey: "checked")
    }
    
    required init?(coder: NSCoder) {
        self.tittle = coder.decodeObject(forKey: "tittle") as? String ?? ""
        self.dudate = coder.decodeObject(forKey: "dudate") as? Date ?? Date()
        self.checked = coder.decodeBool(forKey: "checked")
    }
    
    
    var tittle: String = ""
    
    var dudate: Date = Date()
    
    var checked: Bool = false
    
    var index: Int = 0
    
    init(tittle: String, dudate: Date, checked: Bool, index: Int) {
        self.tittle = tittle
        self.dudate = dudate
        self.checked = checked
        self.index = index
    }
}



struct ToDoItem: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ToDoItem_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItem()
    }
}
