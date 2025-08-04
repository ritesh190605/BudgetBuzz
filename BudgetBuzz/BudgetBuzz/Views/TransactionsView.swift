import SwiftUI

struct TransactionsView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var showingAddTransaction = false
    @State private var selectedFilter: TransactionType?
    @State private var searchText = ""
    
    var filteredTransactions: [Transaction] {
        dataManager.transactions.filter { transaction in
            let matchesFilter = selectedFilter == nil || transaction.type == selectedFilter
            let matchesSearch = searchText.isEmpty || 
                transaction.description.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.name.localizedCaseInsensitiveContains(searchText)
            return matchesFilter && matchesSearch
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search and Filter Bar
                HStack {
                    TextField("Search transactions...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Picker("Filter", selection: $selectedFilter) {
                        Text("All").tag(Optional<TransactionType>.none)
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(Optional(type))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.vertical)
                
                // Transactions List
                List {
                    ForEach(filteredTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                    .onDelete { indexSet in
                        let transactionsToDelete = indexSet.map { filteredTransactions[$0] }
                        for transaction in transactionsToDelete {
                            dataManager.deleteTransaction(transaction)
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionSheet()
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.category.icon)
                .foregroundColor(Color(hex: transaction.category.color))
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                Text(transaction.category.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", transaction.amount))
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}

struct AddTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @State private var amount = ""
    @State private var description = ""
    @State private var selectedCategory: TransactionCategory?
    @State private var selectedType: TransactionType = .expense
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Description", text: $description)
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        Text("Select a category").tag(Optional<TransactionCategory>.none)
                        ForEach(dataManager.categories) { category in
                            Text(category.name).tag(Optional(category))
                        }
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let amount = Double(amount),
                           !description.isEmpty,
                           let category = selectedCategory {
                            let transaction = Transaction(
                                amount: selectedType == .income ? amount : -amount,
                                category: category,
                                description: description,
                                type: selectedType
                            )
                            dataManager.saveTransaction(transaction)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TransactionsView()
        .environmentObject(DataManager())
} 