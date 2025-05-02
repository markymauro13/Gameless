import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
            
            NewGoalsView()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
            
            RecoveryView()
                .tabItem {
                    Label("Recovery", systemImage: "heart.fill")
                }

            LimitLoggerView()
                .tabItem {
                    Label("Limit Logger", systemImage: "clock")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}