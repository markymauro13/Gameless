import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house")
                }
            RecoveryView()
                .tabItem {
                    Label("Recovery", systemImage: "heart")
                }
            LimitLoggerView()
                .tabItem {
                    Label("Limit Logger", systemImage: "clock")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}