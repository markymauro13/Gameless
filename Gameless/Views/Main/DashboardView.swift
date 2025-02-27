import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingResetAlert = false
    @State private var showingStatsEditor = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    
    // Animation states
    @State private var isAnimating = false
    @State private var glowOpacity = 0.0
    
    // Add a new state variable for showing the panic mode
    @State private var showingPanicMode = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.2),
                    Color(red: 0.1, green: 0.05, blue: 0.25),
                    Color(red: 0.15, green: 0.05, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // App title with animated glow
                Text("Gameless")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                            glowOpacity = 0.7
                        }
                    }
                
                // Main card with glass morphism effect
                VStack(spacing: 20) {
                    // Level number with rank side by side
                    HStack(spacing: 10) {
                        Text("lvl \(viewModel.user.streakDays)")
                            .font(.system(size: 52, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 0)
                            .scaleEffect(isAnimating ? 1.05 : 1.0)
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                            .onAppear {
                                isAnimating = true
                            }
                        
                        // Rank title with custom styling
                        Text(viewModel.user.rank)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                    }
                    .padding(.bottom, 5)
                    
                    // Streak info with improved spacing
                    VStack(spacing: 10) {
                        Text("You have been Gameless for:")
                            .font(.system(size: 16))
                            .foregroundColor(Color.white.opacity(0.7))
                        
                        // Days count with enhanced styling
                        Text("\(viewModel.user.streakDays) days")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: Color.white.opacity(0.2), radius: 5, x: 0, y: 0)
                        
                        // Hours button with improved design
                        Text("\(viewModel.user.totalHours) hours")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                    }
                    .padding(.vertical, 5)
                    
                    // XP progress bar with enhanced design
                    VStack(spacing: 8) {
                        // Progress bar with animation
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 6)
                                    .frame(width: geometry.size.width, height: 10)
                                    .foregroundColor(Color.white.opacity(0.1))
                                
                                // Progress fill with gradient
                                RoundedRectangle(cornerRadius: 6)
                                    .frame(width: min(CGFloat(viewModel.user.currentXP)/CGFloat(viewModel.user.maxXP) * geometry.size.width, geometry.size.width), height: 10)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                    )
                            }
                        }
                        .frame(height: 10)
                        
                        // XP text with improved layout
                        HStack {
                            // Show XP gained text if there's a positive value
                            if viewModel.user.recentXPGained > 0 {
                                Text("xp gained: +\(viewModel.user.recentXPGained)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.green.opacity(0.9))
                            } else if viewModel.user.streakDays == 0 {
                                Text("complete actions to gain xp")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.5))
                            } else {
                                Text("complete actions to gain xp")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(Color.white.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            Text("\(viewModel.user.currentXP)/\(viewModel.user.maxXP)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.05))
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 20)
                
                // Action buttons
                HStack(spacing: 20) {
                    // Skill check button
                    Button(action: {
                        viewModel.performSkillCheck()
                    }) {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                )
                            
                            Text("skillcheck")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Meditate button
                    Button(action: {
                        viewModel.performMeditation()
                    }) {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                )
                            
                            Text("meditate")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Reset button
                    Button(action: {
                        showingResetAlert = true
                    }) {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(Color(red: 0.8, green: 0.2, blue: 0.2).opacity(0.8))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                )
                            
                            Text("reset")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .alert(isPresented: $showingResetAlert) {
                        Alert(
                            title: Text("Reset Streak"),
                            message: Text("Are you sure you want to reset your streak? This cannot be undone."),
                            primaryButton: .destructive(Text("Reset")) {
                                viewModel.resetStreak()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
                // Panic mode button
                Button(action: {
                    showingPanicMode = true
                }) {
                    Text("PANIC MODE")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.8, green: 0.2, blue: 0.2))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .sheet(isPresented: $showingPanicMode) {
                    PanicModeView(viewModel: viewModel)
                }
                
                // Development buttons
                HStack(spacing: 10) {
                    Button(action: {
                        hasCompletedOnboarding = false
                    }) {
                        Text("Reset Onboarding")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.7))
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        showingStatsEditor = true
                    }) {
                        Text("Change Stats")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color.purple.opacity(0.7))
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .sheet(isPresented: $showingStatsEditor) {
                StatsEditorView(viewModel: viewModel)
            }
        }
        .onAppear {
            if !hasCompletedOnboarding {
                // Handle onboarding logic
            }
        }
    }
}

// Preview
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}


