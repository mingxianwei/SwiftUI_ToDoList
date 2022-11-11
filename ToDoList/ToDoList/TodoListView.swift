//
//  TodoListView.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/11/2.
//

import SwiftUI

/// 示例 数组
var exampleTodos: [Todo] = [
    Todo(title: "擦地", dudate:  Date()),
    Todo(title:"洗锅", dudate: Date(timeIntervalSince1970: 20000)),
    Todo(title:"看中国新说唱", dudate: Date()),
    Todo(title: "做APP", dudate: Date()),
    Todo(title:"作业", dudate: Date())
]



struct TodoListView: View {
    
//MARK: - === 属性 ===
    @ObservedObject var main: Main

//MARK: - === Body ===
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(self.main.todos) { item in
                VStack {
                    Spacer().frame(height: 15)
                    if item.index == 0 || dateToShortString(date: item.dudate) != dateToShortString(date: self.main.todos[item.index - 1].dudate) {
                        /// 插入时间分组
                        HStack {
                            Spacer().frame(width:30)
                            Text(date2Word(date: item.dudate))
                                .font(.title)
                            Spacer()
                        }
                    }
                    /// 每一个Item
                    HStack {
                        Spacer().frame(width: 20)
                        
                        TodoItemView(main: main, todoIndex: .constant(item.index))
                            .cornerRadius(10)
                            .clipped()
                            .shadow(color: Color("todoItemShadow"), radius: 5)
        
                        Spacer()
                    }
                    .frame(height: 100)  // item 高度
                    .padding(.bottom,20) // item 间距
                }
            }
            
        }.onAppear{  /// 每次进入 就从 沙盒中读取
            readDataFromUserDefalults()
        }
    }
    
    
    
//MARK: - === 方法 ===
    
    /// 将日期转化为 HH:mm 格式字符串
    /// - Parameter date: Date 时间
    /// - Returns: HH:mm格式字符串
   private func dateToShortString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    
    // 从沙盒中读取数据
    /*
     如果沙盒中没有数据 则 读取 exampleTodos
     */
   private func readDataFromUserDefalults()  {
        if let data = UserDefaults.standard.object(forKey: "todos") as? Data {
            var todoList: [Todo] = []
            do {
                todoList =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Todo] ?? []
            } catch {
                print("ERROR")
            }
            
            for todo in todoList {
                if !todo.checked {
                    self.main.todos.append(todo)
                    self.main.sort()
                }
            }
        } else {
            self.main.todos = exampleTodos
            self.main.sort()
        }
    }
    
    
}

//MARK: - === Previews ===

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(main: Main())
    }
}
