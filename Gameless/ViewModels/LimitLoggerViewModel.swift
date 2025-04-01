import Foundation
import SwiftUI

class LimitLoggerViewModel: ObservableObject {
    @Published var gamingSessions: [GamingSession] = []
    private let dataManager = GamelessDataManager.shared
    private let sessionsKey = "gamingSessions"
    
    init() {
        // Uncomment this line to clear all existing sessions (including sample data)
        clearSessions()
    }
    
    // Calculate today's usage in minutes
    func calculateTodayUsage() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return gamingSessions
            .filter { calendar.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.durationMinutes }
    }
    
    // Save a new gaming session
    func saveSession(date: Date, hours: Double, minutes: Int, game: String, notes: String) {
        let totalMinutes = Int(hours * 60) + minutes
        
        let newSession = GamingSession(
            id: UUID(),
            date: date,
            durationMinutes: totalMinutes,
            game: game,
            notes: notes
        )
        
        // Add to beginning of array to show most recent first
        gamingSessions.insert(newSession, at: 0)
        
        // Save to persistent storage
        saveSessions()
    }
    
    // Load sessions from storage
    func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey) {
            if let decoded = try? JSONDecoder().decode([GamingSession].self, from: data) {
                // Sort by most recent date
                self.gamingSessions = decoded.sorted(by: { $0.date > $1.date })
            }
        }
    }
    
    // Save sessions to storage
    private func saveSessions() {
        if let encoded = try? JSONEncoder().encode(gamingSessions) {
            UserDefaults.standard.set(encoded, forKey: sessionsKey)
        }
    }
    
    // Clear all sessions
    func clearSessions() {
        gamingSessions = []
        UserDefaults.standard.removeObject(forKey: sessionsKey)
    }
    
    // Format minutes as "X hr Y min"
    func formatMinutes(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        if hours > 0 {
            return "\(hours) hr \(mins) min"
        } else {
            return "\(mins) min"
        }
    }
    
    // Update gaming limit
    func updateGamingLimit(_ limit: Double) {
        // Update limit in data manager
        _ = dataManager.updateGamingLimit(limit)
    }
} 