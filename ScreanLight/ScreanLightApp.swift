//
//  ScreanLightApp.swift
//  ScreanLight
//
//  Created by 徐晓龙 on 2025/6/2.
//

import SwiftUI

@main
struct ScreanLightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // 强制使用亮色主题
                .statusBarHidden() // 隐藏状态栏以获得更好的照明效果
        }
    }
}
