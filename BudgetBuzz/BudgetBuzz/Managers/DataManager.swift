import Foundation
import SwiftUI

public class DataManager: ObservableObject {
    public static let shared = DataManager()
    
    private init() {}
    
    private let transactionsKey = "transactions"
    private let categoriesKey = "categories"
    
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var categories: [TransactionCategory] = []
    @Published var totalBalance: Double = 0
    
    public func saveTransaction(_ transaction: Transaction) {
        var transactions = loadTransactions()
        transactions.append(transaction)
        saveTransactions(transactions)
    }
    
    public func loadTransactions() -> [Transaction] {
        guard let data = UserDefaults.standard.data(forKey: transactionsKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Transaction].self, from: data)
        } catch {
            print("Error loading transactions: \(error)")
            return []
        }
    }
    
    private func saveTransactions(_ transactions: [Transaction]) {
        do {
            let data = try JSONEncoder().encode(transactions)
            UserDefaults.standard.set(data, forKey: transactionsKey)
        } catch {
            print("Error saving transactions: \(error)")
        }
    }
    
    // MARK: - Category Management
    
    public func saveCategory(_ category: TransactionCategory) {
        var categories = loadCategories()
        categories.append(category)
        saveCategories(categories)
    }
    
    public func loadCategories() -> [TransactionCategory] {
        guard let data = UserDefaults.standard.data(forKey: categoriesKey) else {
            return defaultCategories()
        }
        
        do {
            return try JSONDecoder().decode([TransactionCategory].self, from: data)
        } catch {
            print("Error loading categories: \(error)")
            return defaultCategories()
        }
    }
    
    private func saveCategories(_ categories: [TransactionCategory]) {
        do {
            let data = try JSONEncoder().encode(categories)
            UserDefaults.standard.set(data, forKey: categoriesKey)
        } catch {
            print("Error saving categories: \(error)")
        }
    }
    
    private func defaultCategories() -> [TransactionCategory] {
        return [
            TransactionCategory(name: "Salary", icon: "dollarsign.circle", color: "#4CAF50"),
            TransactionCategory(name: "Rent", icon: "house", color: "#2196F3"),
            TransactionCategory(name: "Utilities", icon: "bolt", color: "#FFC107"),
            TransactionCategory(name: "Food", icon: "fork.knife", color: "#FF9800"),
            TransactionCategory(name: "Transportation", icon: "car", color: "#9C27B0"),
            TransactionCategory(name: "Entertainment", icon: "film", color: "#E91E63"),
            TransactionCategory(name: "Shopping", icon: "cart", color: "#00BCD4"),
            TransactionCategory(name: "Healthcare", icon: "heart", color: "#F44336"),
            TransactionCategory(name: "Education", icon: "book", color: "#673AB7"),
            TransactionCategory(name: "Other", icon: "ellipsis", color: "#607D8B")
        ]
    }
    
    // MARK: - Public Methods
    
    public func deleteTransaction(_ transaction: Transaction) {
        var transactions = loadTransactions()
        transactions.removeAll { $0.id == transaction.id }
        saveTransactions(transactions)
    }
    
    public func updateCategory(_ updatedCategory: TransactionCategory) {
        var categories = loadCategories()
        if let index = categories.firstIndex(where: { $0.id == updatedCategory.id }) {
            categories[index] = updatedCategory
            saveCategories(categories)
        }
    }
    
    public func deleteCategory(_ category: TransactionCategory) {
        var categories = loadCategories()
        categories.removeAll { $0.id == category.id }
        saveCategories(categories)
    }
    
    public func clearAllData() {
        saveTransactions([])
        saveCategories(defaultCategories())
    }
} 