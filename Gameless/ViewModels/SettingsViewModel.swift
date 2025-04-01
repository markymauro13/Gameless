import Foundation
import SwiftUI
import UserNotifications

class SettingsViewModel: ObservableObject {
    // Notification settings
    @Published var notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled") {
        didSet {
            if notificationsEnabled {
                requestNotificationPermission()
            }
        }
    }
    @Published var reminderTime = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "reminderTime")) 
    @Published var soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
    @Published var vibrationEnabled = UserDefaults.standard.bool(forKey: "vibrationEnabled")
    
    // Notification permission status
    @Published var notificationPermissionStatus: UNAuthorizationStatus = .notDetermined
    
    init() {
        // Check current notification permission status
        checkNotificationPermissionStatus()
    }
    
    // Preferences
    @Published var defaultView = UserDefaults.standard.string(forKey: "defaultView") ?? "Daily"
    @Published var startOfWeek = UserDefaults.standard.string(forKey: "startOfWeek") ?? "Monday"
    
    // Request notification permission
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.notificationPermissionStatus = .authorized
                } else {
                    // If permission denied, update the toggle to reflect reality
                    self.notificationsEnabled = false
                    self.notificationPermissionStatus = .denied
                    UserDefaults.standard.set(false, forKey: "notificationsEnabled")
                }
            }
            
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    // Check current notification permission status
    func checkNotificationPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationPermissionStatus = settings.authorizationStatus
                
                // If permission is not granted but toggle is on, update toggle
                if settings.authorizationStatus != .authorized && self.notificationsEnabled {
                    self.notificationsEnabled = false
                    UserDefaults.standard.set(false, forKey: "notificationsEnabled")
                }
            }
        }
    }
    
    // Developer options
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "onboardingCompleted")
    }
    
    func resetAllStats() {
        // Clear relevant UserDefaults or database entries
        // This is a placeholder - implement actual stats reset logic
    }
    
    // Save changes to UserDefaults
    func saveSettings() {
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(reminderTime.timeIntervalSince1970, forKey: "reminderTime")
        UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        UserDefaults.standard.set(vibrationEnabled, forKey: "vibrationEnabled")
        UserDefaults.standard.set(defaultView, forKey: "defaultView")
        UserDefaults.standard.set(startOfWeek, forKey: "startOfWeek")
    }
    
    // App version info
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "\(version) (build \(build))"
    }
} 