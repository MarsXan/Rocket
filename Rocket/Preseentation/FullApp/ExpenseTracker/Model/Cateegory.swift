//
//  Cateegory.swift
//  Rocket
//
//  Created by mohsen mokhtari on 11/7/23.
//

import SwiftData


@Model
class Category{
    var categoryName:String
    @Relationship(deleteRule: .cascade,inverse: \Expense.category)
    var expenses:[Expense]?
    
    init(categoryName: String) {
        self.categoryName = categoryName
    }
}
