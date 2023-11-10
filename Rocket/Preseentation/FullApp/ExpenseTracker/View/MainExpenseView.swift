//
//  MainExpenseView.swift
//  Rocket
//
//  Created by mohsen mokhtari on 11/9/23.
//

import SwiftUI

struct MainExpenseView: View {
    @State private var selectedTab:ExpenseTab = ExpenseTab.expense
    var body: some View {
        TabView{
            ExpensesView(currentTab: $selectedTab)
                .tag(ExpenseTab.expense)
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text(ExpenseTab.expense.rawValue)
                }
            CategoriesView()
                .tag(ExpenseTab.category)
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text(ExpenseTab.category.rawValue)
                    
                }
        }
    }
}

#Preview {
    MainExpenseView()
}
