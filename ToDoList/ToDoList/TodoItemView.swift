//
//  ToDoItem.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/10/28.
//

import SwiftUI


//class Todo: Identifiable,Codable {
class Todo: Identifiable,Encodable,Decodable {   //Encodable 和 Decodable 可以合并成为 Codable
    
//    func encode(with coder: NSCoder) {
//        coder.encode(self.title, forKey: "title")
//        coder.encode(self.dudate, forKey: "dudate")
//        coder.encode(self.checked,forKey: "checked")
//    }
//
//    required init?(coder: NSCoder) {
//        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
//        self.dudate = coder.decodeObject(forKey: "dudate") as? Date ?? Date()
//        self.checked = coder.decodeBool(forKey: "checked")
//    }
    
    //MARK: - ===  Var  ===
    var title: String = ""
    var dudate: Date = Date()
    var checked: Bool = false
    var index: Int = 0
    
    init(title: String, dudate: Date) {
        self.title = title
        self.dudate = dudate
    }
    
    //MARK: - === Codable ===
    
    required init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        self.title      = try container.decode(String.self, forKey: .title)
        self.dudate     = try container.decode(Date.self, forKey: .dudate)
        self.checked    = try container.decode(Bool.self, forKey: .checked)
        self.index      = try container.decode(Int.self, forKey: .index)
    }
    
    enum CodingKeys: CodingKey {
        case title
        case dudate
        case checked
        case index
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.dudate, forKey: .dudate)
        try container.encode(self.checked, forKey: .checked)
        try container.encode(self.index, forKey: .index)
    }
    
    
    
}


/// 空待办事项
var emptyTodo: Todo = Todo(title: "", dudate: Date())
typealias TodoList = [Todo]

extension TodoList: RawRepresentable  {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Todo].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}



struct TodoItemView: View {
    
    @ObservedObject var main: Main
    @Binding var todoIndex: Int
    @State private var checked: Bool = false
    
    /// 将时间转化为 HH:mm格式字符串
    func dateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 8)
        return formatter.string(from: date)
    }
    
    
    var body: some View {
        HStack {
            Button {
                /// 数据备份
                editingMode = true
                editingTodo = self.main.todos[self.todoIndex]
                editingIndex = self.todoIndex

                self.main.detailsTitle = editingTodo.title
                self.main.detialsDueDate = editingTodo.dudate
                self.main.detailsShowing = true
                
            } label: {
                HStack{
                    Rectangle()
                        .fill(Color("theme"))
                        .frame(width: 8)
                        .padding(.trailing,8)
                    VStack(alignment: .leading, spacing: 20.0) {
                        Text(main.todos[self.todoIndex].title)
                            .font(.title)
                            .foregroundColor(Color("todoItemTitle"))
                        
                        HStack {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 15,height: 15)
                                .foregroundColor(Color("todoItemSubTitle"))
                            
                            Spacer()
                                .frame(width: 12)
                            
                            Text(dateToString(date:self.main.todos[self.todoIndex].dudate))
                                .foregroundColor(Color("todoItemSubTitle"))
                                .font(.subheadline)
                            
                            Spacer()
                        }
                    }
                }
            }
            
            Spacer()
            
            Button {
                self.main.todos[self.todoIndex].checked.toggle()
                self.checked =  self.main.todos[self.todoIndex].checked
                
                do {
                    
                    let archivedDate = try JSONEncoder().encode(self.main.todos)
                    
//                    let archivedDate = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                    UserDefaults.standard.set(archivedDate, forKey: "todos")
                    
                } catch {
                    print("error")
                }
                
     
            } label: {
                HStack {
                    Spacer()
                        .frame(width: 12)
                    VStack {
                        Spacer()
                        Image(systemName: self.checked ? "checkmark.square" : "square" )
                            .resizable()
                            .frame(width: 25,height: 25)
                            .foregroundColor(Color("todoItemSubTitle"))
                        Spacer()
                    }
                    Spacer()
                        .frame(width: 12)
                }
            }.onAppear{
                self.checked = self.main.todos[self.todoIndex].checked
            }
        }
        .padding(.trailing, 20.0)
        .background(Color( self.checked ? "todoItem-bg-checked" : "todoItem-bg"))
        .animation(.spring(), value: self.checked)
    }
        
}

struct ToDoItem_Previews: PreviewProvider {
    static var previews: some View {
        
        let main = Main()
        main.todos = exampleTodos
        
       return TodoItemView(main: main, todoIndex: .constant(1) )
    }
}
