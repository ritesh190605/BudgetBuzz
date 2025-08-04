//
//  ContentView.swift
//  BudgetBuzz
//
//  Created by Ritesh Yadav on 05/12/24.
//

import SwiftUI

struct ContentView: View {
    // State variables for managing tabs
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard View
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.pie.fill")
                    Text("Dashboard")
                }
                .tag(0)
            
            // Transactions View
            TransactionsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Transactions")
                }
                .tag(1)
            
            // Budget View
            BudgetView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Budget")
                }
                .tag(2)
            
            // Settings View
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager())
}
