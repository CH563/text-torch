//
//  Item.swift
//  TextTorch
//
//  Created by Liwen on 2025/3/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
