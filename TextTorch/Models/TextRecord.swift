import Foundation
import SwiftData

@Model
final class TextRecord {
    var content: String
    var createdAt: Date
    var fontSize: Double
    var speed: Double
    var colorScheme: Int // 0: 默认, 1: 高对比度1, 2: 高对比度2
    
    init(content: String, fontSize: Double = 48, speed: Double = 1.0, colorScheme: Int = 0) {
        self.content = content
        self.createdAt = Date()
        self.fontSize = fontSize
        self.speed = speed
        self.colorScheme = colorScheme
    }
} 