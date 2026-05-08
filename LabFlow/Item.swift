//
//  Item.swift
//  LabFlow
//
//  Created by 西岡優太 on 2026/05/08.
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
