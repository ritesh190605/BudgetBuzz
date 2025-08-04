import SwiftUI

@MainActor
struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authManager: AuthenticationManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var fullName: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Create Account")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                // Form Fields
                VStack(spacing: 16) {
                    // Full Name Field
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.name)
                        .autocapitalization(.words)
                    
                    // Email Field
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Password Field
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Confirm Password Field
                    HStack {
                        if showConfirmPassword {
                            TextField("Confirm Password", text: $confirmPassword)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                        }
                        
                        Button(action: { showConfirmPassword.toggle() }) {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal, 32)
                
                // Password requirements
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password must contain:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("• At least 8 characters")
                        .font(.caption)
                        .foregroundColor(password.count >= 8 ? .green : .gray)
                    Text("• At least one uppercase letter")
                        .font(.caption)
                        .foregroundColor(password.contains(where: { $0.isUppercase }) ? .green : .gray)
                    Text("• At least one number")
                        .font(.caption)
                        .foregroundColor(password.contains(where: { $0.isNumber }) ? .green : .gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 32)
                
                // Sign Up Button
                Button(action: handleSignUp) {
                    if authManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal, 32)
                .disabled(authManager.isLoading)
                
                // Back to Login
                Button("Already have an account? Login") {
                    dismiss()
                }
                .foregroundColor(.accentColor)
                .padding(.bottom, 20)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func handleSignUp() {
        // Validate inputs
        guard !fullName.isEmpty else {
            alertMessage = "Please enter your full name"
            showAlert = true
            return
        }
        
        guard !email.isEmpty, email.contains("@") else {
            alertMessage = "Please enter a valid email address"
            showAlert = true
            return
        }
        
        guard password.count >= 8,
              password.contains(where: { $0.isUppercase }),
              password.contains(where: { $0.isNumber }) else {
            alertMessage = "Password doesn't meet requirements"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords don't match"
            showAlert = true
            return
        }
        
        Task {
            do {
                try await authManager.signUp(email: email, password: password, fullName: fullName)
                // Dismiss the sign-up sheet after successful registration
                dismiss()
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthenticationManager())
    }
} 