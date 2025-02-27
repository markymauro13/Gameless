import SwiftUI

struct PanicModeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DashboardViewModel
    @State private var showingResetAlert = false
    
    var body: some View {
        ZStack {
            // Black background
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 30) {
                        // Title
                        Text("Panic Mode")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        // Warning text
                        Text("DO NOT GO BACK\nTO GAMING")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                        
                        // Motivational text
                        Text("Don't break your streak for a little dopamine spike. Use your time developing yourself with your own real life desires.")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        
                        // Cons section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Cons of relapsing")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                BulletPoint(text: "wasting your potential")
                                BulletPoint(text: "increased anxiety & depression")
                                BulletPoint(text: "dopamine addiction")
                                BulletPoint(text: "lose sense of self control")
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        Spacer()
                        
                        // "I'll overcome this" button
                        Button(action: {
                            dismiss()
                        }) {
                            Text("I'll overcome this")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.1, green: 0.5, blue: 0.1))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                        
                        // Relapse button
                        Button(action: {
                            showingResetAlert = true
                        }) {
                            Text("I relapsed")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color(red: 0.7, green: 0.1, blue: 0.1))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                        .alert(isPresented: $showingResetAlert) {
                            Alert(
                                title: Text("Reset Streak"),
                                message: Text("Are you sure you want to reset your streak? This cannot be undone."),
                                primaryButton: .destructive(Text("Reset")) {
                                    viewModel.resetStreak()
                                    dismiss()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
        }
    }
}

// Helper view for bullet points
struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.system(size: 18))
                .foregroundColor(.white)
            
            Text(text)
                .font(.system(size: 18))
                .foregroundColor(.white)
        }
    }
}

// Preview
struct PanicModeView_Previews: PreviewProvider {
    static var previews: some View {
        PanicModeView(viewModel: DashboardViewModel())
    }
} 
