import Foundation

public struct Transaction: Identifiable, Codable {
    public let id: UUID
    public let amount: Double
    public let category: TransactionCategory
    public let date: Date
    public let description: String
    public let type: TransactionType
    
    public init(id: UUID = UUID(), amount: Double, category: TransactionCategory, date: Date = Date(), description: String, type: TransactionType) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.description = description
        self.type = type
    }
}

public enum TransactionType: String, Codable {
    case income
    case expense
    case transfer
} 