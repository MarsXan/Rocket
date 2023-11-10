//
//  ScrollCard.swift
//  Rocket-iOS17
//
//  Created by mohsen mokhtari on 11/5/23.
//

import SwiftUI

struct ScrollCard: Identifiable {
    var id: UUID = .init()
    var bgColor: Color
    var balance: String
}
var scrollcards: [ScrollCard] = [
    ScrollCard(bgColor: .red, balance: "$125,000"),
    ScrollCard(bgColor: .blue, balance: "$25,000"),
    ScrollCard(bgColor: .orange, balance: "$25,000"),
    ScrollCard(bgColor: .purple, balance: "$5,000")
]
