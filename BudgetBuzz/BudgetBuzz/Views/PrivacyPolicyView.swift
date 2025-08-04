import SwiftUI

struct PrivacyPolicyView: View {
    private var formattedDate: String {
        "December 5, 2024"  // You can make this dynamic if needed
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Privacy Policy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Last Updated: \(formattedDate)")
                        .foregroundColor(.secondary)
                }
                
                // Introduction
                PolicySection(title: "Introduction") {
                    Text("Welcome to BudgetBuzz. We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we handle your information when you use our app.")
                }
                
                // Data Collection
                PolicySection(title: "Data Collection and Storage") {
                    Text("BudgetBuzz is designed with privacy in mind:")
                    
                    BulletPoint("All your financial data is stored locally on your device")
                    BulletPoint("We do not collect or transmit any personal information")
                    BulletPoint("No data is shared with third parties")
                    BulletPoint("Your transactions and budgets remain completely private")
                }
                
                // Data Usage
                PolicySection(title: "How We Use Your Data") {
                    Text("Your data is used exclusively within the app to:")
                    
                    BulletPoint("Display your transactions and budgets")
                    BulletPoint("Calculate financial statistics")
                    BulletPoint("Generate reports and insights")
                    BulletPoint("Provide budget notifications (if enabled)")
                }
                
                // Data Security
                PolicySection(title: "Data Security") {
                    Text("We implement appropriate security measures:")
                    
                    BulletPoint("All data is stored locally on your device")
                    BulletPoint("Protected by your device's built-in security")
                    BulletPoint("No cloud storage or synchronization")
                    BulletPoint("Data backup is handled through your device's backup system")
                }
                
                // User Rights
                PolicySection(title: "Your Rights") {
                    Text("You have complete control over your data:")
                    
                    BulletPoint("Access all your data within the app")
                    BulletPoint("Delete your data at any time")
                    BulletPoint("Export your data (feature coming soon)")
                    BulletPoint("No need to request data deletion from us")
                }
                
                // Children's Privacy
                PolicySection(title: "Children's Privacy") {
                    Text("BudgetBuzz is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.")
                }
                
                // Changes to Policy
                PolicySection(title: "Changes to This Policy") {
                    Text("We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \"Last Updated\" date.")
                }
                
                // Contact Information
                PolicySection(title: "Contact Us") {
                    Text("If you have any questions about this Privacy Policy, please contact us:")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Link("Email: support@budgetbuzz.com",
                             destination: URL(string: "mailto:support@budgetbuzz.com")!)
                        Link("Website: www.budgetbuzz.com",
                             destination: URL(string: "https://www.budgetbuzz.com")!)
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Supporting Views
struct PolicySection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            content
        }
    }
}

struct BulletPoint: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
            Text(text)
        }
        .padding(.leading)
    }
}

#Preview {
    NavigationView {
        PrivacyPolicyView()
    }
} 