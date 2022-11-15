//
//  TodoDetails.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/11/2.
//

import SwiftUI

struct TodoDetails: View {
    
    //MARK: - === 属性 ===
    @ObservedObject var main:Main

    //MARK: - === Body ===
    var body: some View {
        
        VStack(spacing: 30) {
            // 添加 取消 按钮
            HStack {
                /// 取消按钮
                Button("取消"){
                    ToDoListApp().keyWindow?.endEditing(true)
                    self.main.detailsShowing = false
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                /// 添加按钮
                Button(editingMode ? "完成" : "添加") {
                    ToDoListApp().keyWindow?.endEditing(true)
                    addButtonClicked()
                }
                .disabled(main.detailsTitle == "")
                .buttonStyle(.bordered)
                
            }
            
            // 输入框
            TextField("做点什么", text: $main.detailsTitle)
                .padding(20)
                .foregroundColor(Color("todoItemSubTitle"))
                .background(Color.gray.opacity(0.3))
                .cornerRadius(5)
            
            DatePicker(selection: $main.detialsDueDate) {}
            
            Spacer()
        }
        .padding(20)
        .background(Color("todoDetails-bg"))
        .edgesIgnoringSafeArea(.horizontal)
    }
    
    //MARK: - === 私有方法 ===
    private func addButtonClicked() {
        if editingMode {
            self.main.todos[editingIndex].title = self.main.detailsTitle
            self.main.todos[editingIndex].dudate = self.main.detialsDueDate
        } else {
            let newTodo = Todo(title: self.main.detailsTitle, dudate: self.main.detialsDueDate)
            self.main.todos.append(newTodo)
        }
        self.main.sort()
        do{
            let archivedata = try JSONEncoder().encode(self.main.todos)
//            let archivedata = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
            UserDefaults.standard.set(archivedata, forKey: "todos")
        } catch {
            print("ERROR")
        }
        self.main.detailsShowing = false
    }
    
}

//MARK: - === Preview ===
struct TodoDetails_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetails(main: Main())
    }
}
