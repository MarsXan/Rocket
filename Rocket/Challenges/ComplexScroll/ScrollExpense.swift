//
//  ScrollExpense.swift
//  Rocket-iOS17
//
//  Created by mohsen mokhtari on 11/5/23.
//

import Foundation

import Foundation

struct ScrollExpense: Identifiable {
    var id: UUID = UUID()
    var amountSpent: String
    var product: String
    var spendType: String
}
var scrollExpenses: [ScrollExpense] = [
    ScrollExpense (amountSpent: "$128", product: "Amazon Purchase", spendType: "Groceries"),
    ScrollExpense (amountSpent: "$10", product: "Youtube Premium", spendType: "Streaming"),
    ScrollExpense (amountSpent: "$10", product: "Dribbble", spendType: "Membership"),
    ScrollExpense (amountSpent: "$99", product: "Magic Keyboard", spendType: "Products"),
    ScrollExpense (amountSpent: "$9", product: "Patreon", spendType: "Membership"),
    ScrollExpense (amountSpent: "$100", product: "Instagram", spendType: "Ad Publish"),
    ScrollExpense (amountSpent: "$15", product: "Netflix", spendType: "Streaming"),
    ScrollExpense (amountSpent: "$348", product: "Photoshop", spendType: "Editing"),
    ScrollExpense (amountSpent: "$99", product: "Figma", spendType: "Pro Member"),
    ScrollExpense (amountSpent: "$89", product: "Magic Mouse", spendType: "Products"),
    ScrollExpense (amountSpent: "$1200", product: "Studio Display", spendType: "Products"),
    ScrollExpense (amountSpent: "$39", product: "Sketch Subscription", spendType: "Membership")
    ]
