//
//  ContentView.swift
//  ScreanLight
//
//  Created by 徐晓龙 on 2025/6/2.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var brightness: Double = 1.0 // 屏幕亮度 (0.0-1.0)
    @State private var warmth: Double = 0.0 // 柔光暖度 (0.0-1.0)
    @State private var isIdleDisabled = true // 禁用自动息屏
    @State private var showInfo = false // 显示信息弹窗
    
    var body: some View {
        ZStack {
            // 背景色：根据暖度从白色渐变到淡黄色
            backgroundColor
                .ignoresSafeArea(.all)
                .brightness(brightness - 1.0) // 调整亮度
            
            VStack {
                // 信息按钮
                HStack {
                    Spacer()
                    Button(action: {
                        showInfo.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title2)
                            .foregroundColor(.black.opacity(0.3))
                            .padding()
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // 使用说明文字（半透明，不影响照明）
                if !showInfo {
                    instructionText
                }
                
                Spacer()
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !showInfo {
                        handleDragGesture(value)
                    }
                }
        )
        .onAppear {
            setupIdleTimer()
        }
        .onDisappear {
            restoreIdleTimer()
        }
        .sheet(isPresented: $showInfo) {
            InfoView()
        }
    }
    
    // 背景颜色计算
    private var backgroundColor: Color {
        // 根据warmth值在白色和淡黄色之间插值
        return Color(
            red: 1.0,
            green: 0.95 + (1.0 - 0.95) * (1.0 - warmth),
            blue: 0.8 + (1.0 - 0.8) * (1.0 - warmth)
        )
    }
    
    // 使用说明文字
    private var instructionText: some View {
        VStack(spacing: 20) {
            Text("屏幕手电筒")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.black.opacity(0.3))
            
            VStack(spacing: 8) {
                Text("上下滑动：调节亮度")
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.25))
                
                Text("左右滑动：调节柔光")
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.25))
                
                Text("当前亮度：\(Int(brightness * 100))%")
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.25))
                
                Text("柔光强度：\(Int(warmth * 100))%")
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.25))
            }
        }
    }
    
    // 处理拖拽手势
    private func handleDragGesture(_ value: DragGesture.Value) {
        let translation = value.translation
        
        // 垂直拖拽调节亮度
        if abs(translation.height) > abs(translation.width) {
            // 向上拖拽增加亮度，向下拖拽减少亮度
            let delta = -translation.height / 600.0 // 降低敏感度调节
            brightness = max(0.1, min(1.0, brightness + delta))
        }
        // 水平拖拽调节柔光
        else {
            // 向右拖拽增加暖度，向左拖拽减少暖度
            let delta = translation.width / 600.0 // 降低敏感度调节
            warmth = max(0.0, min(1.0, warmth + delta))
        }
    }
    
    // 禁用自动息屏
    private func setupIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    // 恢复自动息屏
    private func restoreIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}

// 信息视图
struct InfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("应用介绍")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("ScreanLight是一个简单而实用的iOS屏幕手电筒应用，专为需要更柔和照明的用户设计。相比手机自带的强光手电筒，屏幕手电筒提供了更温和的照明选择，特别适合夜间使用。")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("主要功能")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        FeatureRow(title: "白屏照明", description: "使用屏幕白色背景提供照明，亮度可达100%")
                        FeatureRow(title: "手势调光", description: "上下滑动手指轻松调整屏幕亮度")
                        FeatureRow(title: "比例调节柔光", description: "左右滑动按比例调整柔光强度（从纯白到淡黄色渐变）")
                        FeatureRow(title: "屏幕常亮", description: "使用期间屏幕保持常亮状态，不会自动息屏")
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("使用场景")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("• 夜间阅读时需要温和的照明")
                        Text("• 在黑暗中查找物品")
                        Text("• 作为紧急照明工具")
                        Text("• 需要比手机闪光灯更柔和的光线时")
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("使用说明")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}
