//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 明先伟 on 2022/10/28.
//

import SwiftUI

var formatter = DateFormatter()


@main
struct ToDoListApp: App {
    var body: some Scene {

        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 8)
        
        return WindowGroup {
                Home(main: Main())
        }
    }
}
