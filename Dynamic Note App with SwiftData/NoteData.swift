//
//  NoteData.swift
//  Dynamic Note App with SwiftData
//
//  Created by Berkay Yaşar on 21.10.2023.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class NoteData: Identifiable {
    var id: String
    var title: String
    var body: String
    var color: String
    
    init(title: String, body: String, color: String) {
        self.id = UUID().uuidString
        self.title = title
        self.body = body
        self.color = color
    }

}
