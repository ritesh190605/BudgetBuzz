import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingCategoryEditor = false
    @AppStorage("currencySymbol") private var currencySymbol = "₹"
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("budgetWarningThreshold") private var budgetWarningThreshold = 80.0
    
    private let currencies = [
        Currency(symbol: "₹", name: "Indian Rupee"),
        Currency(symbol: "$", name: "US Dollar"),
        Currency(symbol: "€", name: "Euro"),
        Currency(symbol: "£", name: "British Pound"),
        Currency(symbol: "¥", name: "Japanese Yen")
    ]
    
    var body: some View {
        NavigationView {
            List {
                // General Settings
                Section("General") {
                    // Currency Picker
                    Picker("Currency", selection: $currencySymbol) {
                        ForEach(currencies, id: \.symbol) { currency in
                            HStack {
                                Text(currency.symbol)
                                Text(currency.name)
                            }
                            .tag(currency.symbol)
                        }
                    }
                    
                    // Notifications Toggle
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    
                    // Budget Warning Threshold
                    VStack(alignment: .leading) {
                        Text("Budget Warning at")
                        HStack {
                            Slider(value: $budgetWarningThreshold, in: 50...90, step: 5)
                            Text("\(Int(budgetWarningThreshold))%")
                        }
                    }
                }
                
                // Categories Management
                Section("Categories") {
                    NavigationLink {
                        CategoryManagementView()
                    } label: {
                        Label("Manage Categories", systemImage: "tag")
                    }
                }
                
                // Data Management
                Section("Data") {
                    Button(role: .destructive) {
                        showingDeleteConfirmation = true
                    } label: {
                        Label("Clear All Data", systemImage: "trash")
                    }
                }
                
                // About Section
                Section("About") {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }
                    
                    Link(destination: URL(string: "https://www.example.com/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                    
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About BudgetBuzz", systemImage: "info.circle")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .alert("Clear All Data", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                clearAllData()
            }
        } message: {
            Text("This will delete all your transactions and budget data. This action cannot be undone.")
        }
    }
    
    @State private var showingDeleteConfirmation = false
    
    private func clearAllData() {
        dataManager.clearAllData()
    }
}

struct Currency {
    let symbol: String
    let name: String
}

#Preview {
    SettingsView()
        .environmentObject(DataManager())
} 