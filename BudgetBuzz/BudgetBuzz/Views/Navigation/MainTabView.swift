import SwiftUI

struct MainTabView: View {
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            Text("Transactions")
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Transactions")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
} 