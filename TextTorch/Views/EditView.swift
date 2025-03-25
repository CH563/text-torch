import SwiftUI
import SwiftData
import UIKit

struct EditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let record: TextRecord?
    
    @State private var content: String
    @State private var fontSize: Double
    @State private var speed: Double
    @State private var colorScheme: Int
    
    init(record: TextRecord? = nil) {
        self.record = record
        _content = State(initialValue: record?.content ?? "")
        _fontSize = State(initialValue: record?.fontSize ?? 48)
        _speed = State(initialValue: record?.speed ?? 1.0)
        _colorScheme = State(initialValue: record?.colorScheme ?? 0)
    }
    
    private let speedOptions = [1.0, 1.5, 2.0]
    private let colorSchemes = [
        (name: "默认", foreground: Color.white, background: Color.black),
        (name: "高对比度1", foreground: Color.yellow, background: Color.black),
        (name: "高对比度2", foreground: Color.green, background: Color.black)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 预览区域
                ScrollView {
                    Text(content.isEmpty ? "输入文字预览效果" : content)
                        .font(.system(size: fontSize))
                        .foregroundColor(colorSchemes[colorScheme].foreground)
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.4)
                        .background(colorSchemes[colorScheme].background)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                // 设置面板
                VStack(spacing: 16) {
                    // 字体大小滑块
                    VStack(alignment: .leading) {
                        Text("字体大小: \(Int(fontSize))px")
                        Slider(value: $fontSize, in: 24...120, step: 1)
                    }
                    
                    // 速度选择
                    HStack {
                        Text("播放速度:")
                        ForEach(speedOptions, id: \.self) { speedOption in
                            Button(action: { speed = speedOption }) {
                                Text("\(speedOption)x")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(speed == speedOption ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(speed == speedOption ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    
                    // 颜色方案
                    HStack {
                        Text("颜色方案:")
                        ForEach(0..<colorSchemes.count, id: \.self) { index in
                            Button(action: { colorScheme = index }) {
                                Text(colorSchemes[index].name)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(colorScheme == index ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(colorScheme == index ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                
                // 文本输入区域
                TextEditor(text: $content)
                    .frame(height: 100)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
            }
            .navigationTitle(record == nil ? "新建文本" : "编辑文本")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        if let record = record {
                            // 更新现有记录
                            record.content = content
                            record.fontSize = fontSize
                            record.speed = speed
                            record.colorScheme = colorScheme
                        } else {
                            // 创建新记录
                            let newRecord = TextRecord(
                                content: content,
                                fontSize: fontSize,
                                speed: speed,
                                colorScheme: colorScheme
                            )
                            modelContext.insert(newRecord)
                        }
                        dismiss()
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
    }
} 