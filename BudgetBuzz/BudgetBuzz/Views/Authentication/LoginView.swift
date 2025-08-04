import SwiftUI

@MainActor
struct LoginView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showSignUp = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Logo and Title
            VStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
                
                Text("BudgetBuzz")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 60)
            
            // Login Form
            VStack(spacing: 16) {
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
                            .textContentType(.password)
                    } else {
                        SecureField("Password", text: $password)
                            .textContentType(.password)
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 32)
            
            // Login Button
            Button(action: handleLogin) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 32)
            
            // Forgot Password
            Button("Forgot Password?") {
                // Handle forgot password
            }
            .foregroundColor(.accentColor)
            
            Spacer()
            
            // Sign Up Link
            HStack {
                Text("Don't have an account?")
                Button("Sign Up") {
                    showSignUp = true
                }
                .foregroundColor(.accentColor)
            }
            .padding(.bottom, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
    }
    
    private func handleLogin() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        guard email.contains("@") else {
            alertMessage = "Please enter a valid email"
            showAlert = true
            return
        }
        
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationManager())
    }
} 