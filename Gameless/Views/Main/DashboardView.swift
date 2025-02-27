import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingResetAlert = false
    @State private var showingStatsEditor = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true
    
    // Animation states
    @State private var isAnimating = false
    @State private var glowOpacity = 0.0
    
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
                    viewModel.activatePanicMode()
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

// Stats Editor View
struct StatsEditorView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var streakDays: Int = 0
    @State private var totalHours: Int = 0
    @State private var currentXP: Int = 0
    
    // Preset profiles
    let presetProfiles: [PresetProfile] = [
        PresetProfile(name: "New User", days: 0, xp: 0, color: .gray),
        PresetProfile(name: "1 Week", days: 7, xp: 30, color: .blue),
        PresetProfile(name: "2 Weeks", days: 14, xp: 45, color: .green),
        PresetProfile(name: "1 Month", days: 30, xp: 60, color: .purple),
        PresetProfile(name: "3 Months", days: 90, xp: 75, color: .orange),
        PresetProfile(name: "6 Months", days: 180, xp: 85, color: .red),
        PresetProfile(name: "1 Year", days: 365, xp: 95, color: .pink)
    ]
    
    // XP presets
    let xpPresets: [XPPreset] = [
        XPPreset(name: "0 XP", xp: 0, color: .gray),
        XPPreset(name: "25 XP", xp: 25, color: .green),
        XPPreset(name: "50 XP", xp: 50, color: .blue),
        XPPreset(name: "75 XP", xp: 75, color: .purple),
        XPPreset(name: "100 XP", xp: 100, color: .orange)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(red: 0.05, green: 0.05, blue: 0.15)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Preset profiles section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Preset Profiles")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(presetProfiles) { profile in
                                    Button(action: {
                                        applyPreset(days: profile.days, xp: profile.xp)
                                    }) {
                                        VStack(spacing: 6) {
                                            Text(profile.name)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.white)
                                            
                                            Text("\(profile.days) days")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 14)
                                        .background(profile.color.opacity(0.3))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // XP presets section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("XP Presets")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(xpPresets) { preset in
                                    Button(action: {
                                        currentXP = preset.xp
                                    }) {
                                        Text(preset.name)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(preset.color.opacity(0.3))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // Stats editor form
                    VStack(spacing: 20) {
                        // Streak days
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Streak Days")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(streakDays)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Slider(value: Binding(
                                get: { Double(streakDays) },
                                set: { 
                                    streakDays = Int($0)
                                    totalHours = streakDays * 24
                                }
                            ), in: 0...365, step: 1)
                            .accentColor(.blue)
                        }
                        
                        // Total hours (read-only)
                        HStack {
                            Text("Total Hours")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(totalHours)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        
                        // Current XP
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Current XP")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Text("\(currentXP)/100")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Slider(value: Binding(
                                get: { Double(currentXP) },
                                set: { currentXP = Int($0) }
                            ), in: 0...100, step: 1)
                            .accentColor(.green)
                        }
                        
                        // Rank preview
                        HStack {
                            Text("Rank")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(viewModel.getRankForDaysAndXP(days: streakDays, xp: currentXP))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.05))
                    )
                    .padding(.horizontal, 20)
                    
                    // Apply button
                    Button(action: {
                        applyChanges()
                        dismiss()
                    }) {
                        Text("Apply Changes")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 4)
                            )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                .navigationTitle("Edit Stats")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                    }
                }
                .onAppear {
                    // Initialize with current values
                    streakDays = viewModel.user.streakDays
                    currentXP = viewModel.user.currentXP
                    totalHours = viewModel.user.totalHours
                }
            }
        }
    }
    
    private func applyPreset(days: Int, xp: Int) {
        streakDays = days
        currentXP = xp
        totalHours = days * 24
    }
    
    private func applyChanges() {
        // Update user stats through the ViewModel
        viewModel.updateUserStats(streakDays: streakDays, currentXP: currentXP)
    }
}

// Helper structs for presets
struct PresetProfile: Identifiable {
    var id: String { name }
    let name: String
    let days: Int
    let xp: Int
    let color: Color
}

struct XPPreset: Identifiable {
    var id: String { name }
    let name: String
    let xp: Int
    let color: Color
}

// Preview
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}


