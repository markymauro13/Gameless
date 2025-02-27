//
//  ContentView.swift
//  Gameless
//
//  Created by Mark Mauro on 2/14/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            // Dark background for the entire app
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            if hasCompletedOnboarding {
                // Main app interface
                MainTabView()
            } else {
                // Onboarding flow
                OnboardingView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
