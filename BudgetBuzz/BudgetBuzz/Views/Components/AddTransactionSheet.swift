import SwiftUI

struct AddTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    @State private var title = ""
    @State private var amount = ""
    @State private var type: TransactionType = .expense
    @State private var selectedCategory: TransactionCategory?
    @State private var note = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                // Amount and Type Section
                Section {
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Type", selection: $type) {
                        Text("Expense").tag(TransactionType.expense)
                        Text("Income").tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                }
                
                // Transaction Details Section
                Section {
                    TextField("Title", text: $title)
                    
                    // Category Picker
                    NavigationLink {
                        CategoryPickerView(selectedCategory: $selectedCategory)
                    } label: {
                        HStack {
                            Text("Category")
                            Spacer()
                            if let category = selectedCategory {
                                Label(category.name, systemImage: category.icon)
                            } else {
                                Text("Select")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                // Note Section
                Section {
                    TextField("Note (Optional)", text: $note)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
    
    private var isValid: Bool {
        guard let _ = Double(amount),
              !title.isEmpty,
              selectedCategory != nil else {
            return false
        }
        return true
    }
    
    private func saveTransaction() {
        guard let amount = Double(amount),
              let category = selectedCategory else { return }
        
        let transaction = Transaction(
            amount: amount,
            title: title,
            category: category,
            type: type,
            date: date,
            note: note.isEmpty ? nil : note
        )
        
        dataManager.addTransaction(transaction)
        dismiss()
    }
} 