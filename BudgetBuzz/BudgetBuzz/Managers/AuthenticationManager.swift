import SwiftUI

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var currentUser: User?
    
    private let userEmailKey = "userEmail"
    private let userIdKey = "userId"
    private let userFullNameKey = "userFullName"
    
    struct User {
        let id: String
        let email: String
        let fullName: String
    }
    
    init() {
        // Load saved user data on init
        loadSavedUser()
    }
    
    private func loadSavedUser() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let email = UserDefaults.standard.string(forKey: self.userEmailKey),
               let id = UserDefaults.standard.string(forKey: self.userIdKey),
               let fullName = UserDefaults.standard.string(forKey: self.userFullNameKey) {
                self.currentUser = User(id: id, email: email, fullName: fullName)
                self.isAuthenticated = true
            }
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let user = User(id: UUID().uuidString, email: email, fullName: "Test User")
        await saveUserToDefaults(user)
        self.currentUser = user
        self.isAuthenticated = true
    }
    
    @MainActor
    func signUp(email: String, password: String, fullName: String) async throws {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let user = User(id: UUID().uuidString, email: email, fullName: fullName)
        await saveUserToDefaults(user)
        self.currentUser = user
        self.isAuthenticated = true
    }
    
    @MainActor
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        Task {
            await clearUserDefaults()
        }
    }
    
    private func saveUserToDefaults(_ user: User) async {
        await MainActor.run {
            UserDefaults.standard.set(user.email, forKey: userEmailKey)
            UserDefaults.standard.set(user.id, forKey: userIdKey)
            UserDefaults.standard.set(user.fullName, forKey: userFullNameKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private func clearUserDefaults() async {
        await MainActor.run {
            UserDefaults.standard.removeObject(forKey: userEmailKey)
            UserDefaults.standard.removeObject(forKey: userIdKey)
            UserDefaults.standard.removeObject(forKey: userFullNameKey)
            UserDefaults.standard.synchronize()
        }
    }
} 