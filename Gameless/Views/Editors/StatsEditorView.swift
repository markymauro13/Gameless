import SwiftUI

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
struct StatsEditorView_Previews: PreviewProvider {
    static var previews: some View {
        StatsEditorView(viewModel: DashboardViewModel())
    }
} 