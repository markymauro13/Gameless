import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingResetConfirmation = false
    @State private var selectedTab = 0
    
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
            
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .bold()
                
                Picker("", selection: $selectedTab) {
                    Text("About").tag(0)
                    Text("Notifications").tag(1)
                    Text("Preferences").tag(2)
                    Text("Developer").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if selectedTab == 0 {
                            aboutSection
                        } else if selectedTab == 1 {
                            notificationsSection
                        } else if selectedTab == 2 {
                            preferencesSection
                        } else {
                            developerSection
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .foregroundColor(.white)
        }
        .onDisappear {
            viewModel.saveSettings()
        }
        .alert(isPresented: $showingResetConfirmation) {
            Alert(
                title: Text("Reset All Stats"),
                message: Text("Are you sure you want to reset all your stats? This action cannot be undone."),
                primaryButton: .destructive(Text("Reset")) {
                    viewModel.resetAllStats()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - UI Sections
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About Gameless")
                .font(.headline)
                .padding(.bottom, 4)
            
            Text("Gameless helps you overcome gaming addiction and reclaim your life. By tracking your gaming-free days, you can visualize your progress and build healthier habits.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
            
            Text("Benefits of Reducing Gaming")
                .font(.headline)
                .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 8) {
                BenefitRow(icon: "brain", text: "Improved focus and concentration")
                BenefitRow(icon: "clock", text: "More time for meaningful activities")
                BenefitRow(icon: "person.fill", text: "Better real-world social connections")
                BenefitRow(icon: "bed.double", text: "Healthier sleep patterns")
                BenefitRow(icon: "heart", text: "Reduced anxiety and stress")
            }
            .padding(.bottom, 8)
            
            Text("How to Use This App")
                .font(.headline)
                .padding(.bottom, 4)
            
            Text("Track your gaming-free days, set goals, and celebrate your milestones. Use the daily check-in feature to maintain accountability and build a streak of gaming-free days.")
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
            
            Text("Need Help?")
                .font(.headline)
                .padding(.bottom, 4)
            
            Link(destination: URL(string: "https://gamequitters.com/resources/")!) {
                HStack {
                    Text("Visit Game Quitters for Resources")
                    Spacer()
                    Image(systemName: "link")
                }
            }
            .foregroundColor(.blue)
        }
        .padding()
        .background(Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.5))
        .cornerRadius(10)
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            if viewModel.notificationsEnabled {
                DatePicker("Daily Reminder Time", 
                           selection: $viewModel.reminderTime,
                           displayedComponents: .hourAndMinute)
                
                Toggle("Sound", isOn: $viewModel.soundEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                
                Toggle("Vibration", isOn: $viewModel.vibrationEnabled)
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
        }
        .padding()
        .background(Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.5))
        .cornerRadius(10)
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Default View")
                Spacer()
                Picker("", selection: $viewModel.defaultView) {
                    Text("Daily").tag("Daily")
                    Text("Weekly").tag("Weekly")
                    Text("Monthly").tag("Monthly")
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            HStack {
                Text("Start of Week")
                Spacer()
                Picker("", selection: $viewModel.startOfWeek) {
                    Text("Monday").tag("Monday")
                    Text("Sunday").tag("Sunday")
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .padding()
        .background(Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.5))
        .cornerRadius(10)
    }
    
    private var developerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                viewModel.resetOnboarding()
            }) {
                HStack {
                    Text("Reset Onboarding")
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                }
            }
            
            Button(action: {
                showingResetConfirmation = true
            }) {
                HStack {
                    Text("Reset All Stats")
                    Spacer()
                    Image(systemName: "trash")
                }
            }
            .foregroundColor(.red)
            
            HStack {
                Text("App Version")
                Spacer()
                Text(viewModel.appVersion)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(red: 0.15, green: 0.15, blue: 0.25).opacity(0.5))
        .cornerRadius(10)
    }
}

// Helper view for benefit items
struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
            Spacer()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
