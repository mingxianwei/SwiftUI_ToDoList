//
//  Home.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/11/2.
//

import SwiftUI

/// 是否正在编辑待办事项
var editingMode: Bool = false
/// 备份正在编辑的待办事项
var editingTodo: Todo = emptyTodo
/// 正在编辑的待办事项的索引
var editingIndex: Int = 0


//MARK: - === ViewModel ===

// Model
class Main: ObservableObject {
    
    @Published var todos: [Todo] = []
//    @AppStorage("todos") var todos:TodoList = TodoList()
    
    @Published var detailsShowing: Bool = false
    @Published var detailsTitle: String = ""
    @Published var detialsDueDate: Date = Date()
    
    func sort() {
        /// 按照时间排序
        self.todos.sort { $0.dudate.timeIntervalSince1970 > $1.dudate.timeIntervalSince1970 }
        
        /// 给下标赋值
        for i in 0 ..< self.todos.count {
            self.todos[i].index = i
        }
    }
}

// MARK: - View
struct Home: View {
    
    @ObservedObject var main: Main

    var body: some View {
        NavigationView {
            ZStack(alignment: .center){

                TodoListView(main: main)
                    .blur(radius: main.detailsShowing ? 50 : 0)

                ZStack (alignment: .bottomTrailing){
                    /* 需要使用背景将这个Zstack 填满
                       防止在滑动时候 外部Zstack变化导致Button 飘动的Bug
                     */
                    Color.clear.opacity(0.3)
                    
                    Button(action: buttonClicked, label: { BtnAdd() })
                        .offset(x: -60,y: -120)
                        .blur(radius: main.detailsShowing ? 50 : 0)
                        .animation(.spring(), value: main.detailsShowing)
                    
                }
                .edgesIgnoringSafeArea(.vertical)
                
                TodoDetails(main: main)
                    .offset(x: 0 ,y: main.detailsShowing ? 0 : UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.2), value: main.detailsShowing)
            }
            .navigationTitle(Text("待办事项"))
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.automatic)
        }

    }
    
    func buttonClicked() {
        editingMode = false
        editingTodo = emptyTodo
        self.main.detailsTitle = ""
        self.main.detialsDueDate = Date()
        self.main.detailsShowing = true

    }
}


// MARK: - SubView

/// + 号按钮View
struct BtnAdd: View {
    var size: CGFloat = 65.0
    var body: some View{
        ZStack {
            Circle()
                .fill(Color("btnAdd-bg"))
                .frame(width: self.size, height: self.size)
                .shadow(color: Color("btnAdd-shadow"), radius: 10)
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: self.size,height: self.size)
                .foregroundColor(Color.blue)
        }
    }
}

// MARK: - Preview
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(main: Main())
    }
}
