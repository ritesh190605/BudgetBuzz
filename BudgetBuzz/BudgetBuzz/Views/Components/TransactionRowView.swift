private func formatAmount(_ amount: Double, type: TransactionType) -> String {
    let formattedAmount = amount.formatAsCurrency()
    return type == .income ? "+\(formattedAmount)" : "-\(formattedAmount)"
} 