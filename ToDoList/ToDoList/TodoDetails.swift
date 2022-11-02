//
//  TodoDetails.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/11/2.
//

import SwiftUI

struct TodoDetails: View {
    
    @ObservedObject var main:Main
    
    var body: some View {
        VStack{
            
            HStack {
                
                Button {
                    UIApplication.shared.keyWindow?.endEditing(true)
                    
                    self.main.detailsShowing = false
                    
                } label: {
                    Text("取消")
                        .padding()
                }
                
                Spacer()
                
                Button {
                    UIApplication.shared.keyWindow?.endEditing(true)
                    if editingMode {
                        self.main.todos[editingIndex].title = self.main.detailsTitle
                        self.main.todos[editingIndex].dudate = self.main.detialsDueDate
                        
                    } else {
                        let newTodo = Todo(title: self.main.detailsTitle, dudate: self.main.detialsDueDate)
                        self.main.todos.append(newTodo)
                        
                    }
                    
                    self.main.sort()
                    do{
                        let archivedata = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                        UserDefaults.standard.set(archivedata, forKey: "todos")
                    } catch {
                        print("ERROR")
                    }
                    
                    self.main.detailsShowing = false
                    
                } label: {
                    Text(editingMode ? "完成" : "添加")
                        .padding()
                }.disabled(main.detailsTitle == "")
                
            }.padding(.bottom,20)
            
            TextField("做点什么", text: $main.detailsTitle)
                .padding(8)
                .foregroundColor(Color("todoItemSubTitle"))
            
            DatePicker(selection: $main.detialsDueDate) {
                
            }.padding()
            Spacer()
        }
        .padding()
        .background(Color("todoDetails-bg"))
        .edgesIgnoringSafeArea(.horizontal)
    }
}

struct TodoDetails_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetails(main: Main())
    }
}
