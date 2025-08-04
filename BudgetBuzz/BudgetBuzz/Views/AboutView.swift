import SwiftUI

struct AboutView: View {
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Image("AppIcon") // Make sure you have this in your asset catalog
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                    
                    Text("BudgetBuzz")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Version \(appVersion) (\(buildNumber))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            
            Section("Developer") {
                LabeledContent("Developer", value: "Ritesh Yadav")
                Link(destination: URL(string: "mailto:support@example.com")!) {
                    LabeledContent("Contact", value: "support@example.com")
                }
            }
            
            Section("App Info") {
                NavigationLink {
                    CreditsView()
                } label: {
                    Text("Credits & Acknowledgments")
                }
                
                NavigationLink {
                    WhatsNewView()
                } label: {
                    Text("What's New")
                }
            }
            
            Section("Legal") {
                NavigationLink {
                    TermsOfServiceView()
                } label: {
                    Text("Terms of Service")
                }
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Supporting Views
struct CreditsView: View {
    var body: some View {
        List {
            Section("Frameworks") {
                Text("SwiftUI")
                Text("Foundation")
            }
            
            Section("Design") {
                Text("SF Symbols")
                Text("Apple Human Interface Guidelines")
            }
        }
        .navigationTitle("Credits")
    }
}

struct WhatsNewView: View {
    var body: some View {
        List {
            Section("Version 1.0") {
                ChangeLogItem(
                    title: "Initial Release",
                    description: "Welcome to BudgetBuzz!",
                    icon: "star.fill"
                )
                ChangeLogItem(
                    title: "Transaction Management",
                    description: "Add, edit, and track your transactions",
                    icon: "list.bullet"
                )
                ChangeLogItem(
                    title: "Budget Categories",
                    description: "Organize spending with custom categories",
                    icon: "folder.fill"
                )
                ChangeLogItem(
                    title: "Monthly Overview",
                    description: "Track your monthly spending and budget",
                    icon: "chart.pie.fill"
                )
            }
        }
        .navigationTitle("What's New")
    }
}

struct ChangeLogItem: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
            }
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Terms of Service")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Last updated: \(formattedDate)")
                    .foregroundColor(.secondary)
                
                Text("By using this app, you agree to the following terms:")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 12) {
                    TermsItem(
                        title: "Use of App",
                        description: "This app is provided 'as is' and is intended for personal financial management."
                    )
                    
                    TermsItem(
                        title: "Data Responsibility",
                        description: "You are responsible for managing and backing up your data."
                    )
                    
                    TermsItem(
                        title: "Modifications",
                        description: "We reserve the right to modify or discontinue the app at any time."
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

struct TermsItem: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        AboutView()
    }
} 