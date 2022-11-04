//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/10/28.
//

import SwiftUI

@main
struct ToDoListApp: App {
    /// 添加KeyWindow
    let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first

    var body: some Scene {
        WindowGroup {
                Home(main: Main())
        }
    }
}
