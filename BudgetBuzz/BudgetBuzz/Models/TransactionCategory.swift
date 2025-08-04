import Foundation

public struct TransactionCategory: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let icon: String
    public let color: String
    
    public init(id: UUID = UUID(), name: String, icon: String, color: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
    
    public static func == (lhs: TransactionCategory, rhs: TransactionCategory) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
} 