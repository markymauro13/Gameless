import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var selectedGoal: String?
    @State private var gamingLimit: Double = 1.0 // Default 1 hour (recommended)
    
    var body: some View {
        TabView(selection: $currentPage) {
            // Landing page
            LandingView(onContinue: {
                withAnimation {
                    currentPage = 1
                }
            })
            .tag(0)
            
            // Goals page
            GoalsView(selectedGoal: $selectedGoal, onContinue: {
                withAnimation {
                    currentPage = 2
                }
            })
            .tag(1)
            
            // Accountability page
            AccountabilityView(onContinue: {
                withAnimation {
                    currentPage = 3
                }
            })
            .tag(2)
            
            // Gaming limit page
            GamingLimitView(gamingLimit: $gamingLimit, onContinue: {
                withAnimation {
                    currentPage = 4
                }
            })
            .tag(3)
            
            // Control page
            ControlView(
                selectedGoal: selectedGoal,
                gamingLimit: gamingLimit,
                onFinish: {
                    // Save user preferences
                    UserDefaults.standard.set(selectedGoal, forKey: "selectedGoal")
                    UserDefaults.standard.set(gamingLimit, forKey: "gamingLimit")
                    
                    // Complete onboarding
                    hasCompletedOnboarding = true
                }
            )
            .tag(4)
        }
        .tabViewStyle(.page)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
    }
} 