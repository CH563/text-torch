import SwiftUI
import SwiftData

struct PlayView: View {
    let record: TextRecord
    @Environment(\.dismiss) private var dismiss
    @State private var isLocked = false
    @State private var isPlaying = true
    @State private var offset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    
    private let colorSchemes = [
        (foreground: Color.white, background: Color.black),
        (foreground: Color.yellow, background: Color.black),
        (foreground: Color.green, background: Color.black)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景
                colorSchemes[record.colorScheme].background
                    .ignoresSafeArea()
                
                VStack {
                    // 顶部导航栏
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(colorSchemes[record.colorScheme].foreground)
                        }
                        .disabled(isLocked)
                        
                        Spacer()
                        
                        Button(action: { isLocked.toggle() }) {
                            Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                                .font(.title2)
                                .foregroundColor(colorSchemes[record.colorScheme].foreground)
                        }
                    }
                    .padding()
                    
                    // 滚动文本
                    ScrollView {
                        Text(record.content)
                            .font(.system(size: record.fontSize))
                            .foregroundColor(colorSchemes[record.colorScheme].foreground)
                            .frame(maxWidth: .infinity)
                            .offset(y: offset)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if !isLocked {
                                    dragOffset = value.translation.width
                                }
                            }
                            .onEnded { value in
                                if !isLocked {
                                    if value.translation.width > 50 {
                                        isPlaying = true
                                    } else if value.translation.width < -50 {
                                        isPlaying = false
                                    }
                                    dragOffset = 0
                                }
                            }
                    )
                    
                    // 底部控制栏
                    if !isLocked {
                        HStack {
                            Button(action: { isPlaying.toggle() }) {
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.title)
                                    .foregroundColor(colorSchemes[record.colorScheme].foreground)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            Text("\(String(format: "%.1f", record.speed))x")
                                .foregroundColor(colorSchemes[record.colorScheme].foreground)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            startAnimation()
        }
        .onChange(of: isPlaying) { oldValue, newValue in
            if newValue {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 20 / record.speed)) {
            offset = -1000 // 根据实际文本长度调整
        }
    }
} 