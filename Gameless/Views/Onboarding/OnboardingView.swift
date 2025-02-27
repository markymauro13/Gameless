import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedGoal: String?
    @State private var gamingLimit: Double = 1.0 // Default 1 hour (recommended)
    
    // Goals options
    let goals = [
        "Reduce gaming time",
        "Quit gaming completely",
        "Learn skills",
        "Focus on health & fitness"
    ]
    
    // Goal icons
    let goalIcons = [
        "⏱️",
        "🚫",
        "📚",
        "🏋️"
    ]
    
    var body: some View {
        TabView(selection: $currentPage) {
            // Landing page
            landingView
                .tag(0)
            
            // Goals page
            goalsView
                .tag(1)
            
            // Accountability page
            accountabilityView
                .tag(2)
            
            // Gaming limit page
            gamingLimitView
                .tag(3)
            
            // Control page
            controlView
                .tag(4)
        }
        .tabViewStyle(.page)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Component Views
    
    private var landingView: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Spacer()
                
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.3))
                            .frame(width: 150, height: 150)
                    )
                
                Text("Gameless")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                Text("helps you limit gaming, regain focus, and be more productive")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentPage = 1
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
    }
    
    private var goalsView: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gameless")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("What brings you here?")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    ForEach(0..<goals.count, id: \.self) { index in
                        Button(action: {
                            selectedGoal = goals[index]
                        }) {
                            HStack {
                                Text(goalIcons[index])
                                    .font(.title2)
                                    .padding(.trailing, 5)
                                
                                Text(goals[index])
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if selectedGoal == goals[index] {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding()
                            .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentPage = 2
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
                .disabled(selectedGoal == nil)
                .opacity(selectedGoal == nil ? 0.5 : 1)
            }
            .padding()
        }
    }
    
    private var accountabilityView: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gameless")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("Stay accountable.")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Gameless helps you track gaming habits and build healthier routines.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.blue)
                        Text("Self Reporting")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.blue)
                        Text("Streaks")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.blue)
                        Text("Goal tracking")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentPage = 3
                    }
                }) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
    }
    
    private var gamingLimitView: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gameless")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("How Much Gaming Is Right for You?")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("\(gamingLimit == 1 ? "1 hr / day (Recommended)" : "\(Int(gamingLimit)) hrs / day")")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top)
                
                VStack(spacing: 10) {
                    Slider(value: $gamingLimit, in: 0...8, step: 1)
                        .accentColor(.blue)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("No Gaming")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("Gamer")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentPage = 4
                    }
                }) {
                    Text("Set Limit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
    }
    
    private var controlView: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gameless")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("You're in control.")
                    .font(.title2)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Only you can level up your life. But, we can help.")
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    Text("Make sure to enable notifications to stay connected to your Gameless journey.")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    // Save user preferences
                    UserDefaults.standard.set(selectedGoal, forKey: "selectedGoal")
                    UserDefaults.standard.set(gamingLimit, forKey: "gamingLimit")
                    
                    // Complete onboarding
                    hasCompletedOnboarding = true
                }) {
                    Text("Finish Setup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
    }
} 