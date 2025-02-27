import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    // User data
    @Published var user: User
    
    private var dataManager: GamelessDataManager
    private var rankService: RankService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: GamelessDataManager = GamelessDataManager.shared, 
         rankService: RankService = RankService.shared) {
        self.dataManager = dataManager
        self.rankService = rankService
        self.user = dataManager.loadUser()
        setupTimers()
    }
    
    // Setup timers for daily check-ins
    private func setupTimers() {
        // Check for streak updates daily
        Timer.publish(every: 3600, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkAndUpdateStreak()
            }
            .store(in: &cancellables)
    }
    
    // Check and update streak
    func checkAndUpdateStreak() {
        user = dataManager.checkAndUpdateStreak()
    }
    
    // Add XP to user
    func addXP(_ amount: Int) {
        user = dataManager.addXP(amount)
    }
    
    // Reset streak (for testing or if user relapses)
    func resetStreak() {
        user = dataManager.resetStreak()
    }
    
    // Perform skill check action
    func performSkillCheck() {
        // Logic for skill check
        addXP(10)
    }
    
    // Perform meditation action
    func performMeditation() {
        // Logic for meditation
        addXP(15)
    }
    
    // Activate panic mode
    func activatePanicMode() {
        // Logic for panic mode
        // Could send notifications, show emergency contacts, etc.
    }
    
    // Update gaming limit
    func updateGamingLimit(_ limit: Double) {
        user = dataManager.updateGamingLimit(limit)
    }
    
    // Update selected goal
    func updateSelectedGoal(_ goal: String) {
        user = dataManager.updateSelectedGoal(goal)
    }
    
    // Update user stats (for development purposes)
    func updateUserStats(streakDays: Int, currentXP: Int) {
        // Calculate total hours based on streak days
        let totalHours = streakDays * 24
        
        user = dataManager.updateUserStats(streakDays: streakDays, totalHours: totalHours, currentXP: currentXP)
    }
    
    // Apply a preset profile
    func applyPresetProfile(days: Int, xp: Int) {
        updateUserStats(streakDays: days, currentXP: xp)
    }
    
    // Get rank for a specific number of streak days and XP
    func getRankForDaysAndXP(days: Int, xp: Int) -> String {
        return rankService.getFullRank(days: days, xp: xp)
    }
} 