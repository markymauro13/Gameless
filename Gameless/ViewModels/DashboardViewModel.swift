import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    // User data
    @Published var user: User
    
    // Track daily check-in status
    @Published var hasCheckedInToday: Bool = false
    
    private var dataManager: GamelessDataManager
    private var rankService: RankService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: GamelessDataManager = GamelessDataManager.shared, 
         rankService: RankService = RankService.shared) {
        self.dataManager = dataManager
        self.rankService = rankService
        self.user = dataManager.loadUser()
        
        // Check if user has already checked in today
        checkDailyCheckInStatus()
        
        setupTimers()
        
        // Debug print to check initial XP values
        print("Initial XP Values: \(user.currentXP)/\(user.maxXP)")
    }
    
    // Setup timers for daily check-ins
    private func setupTimers() {
        // Check for streak updates daily
        Timer.publish(every: 3600, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkAndUpdateStreak()
                self?.checkDailyCheckInStatus() // Reset check-in status at midnight
            }
            .store(in: &cancellables)
    }
    
    // Check if user has already checked in today
    private func checkDailyCheckInStatus() {
        let lastCheckInDate = UserDefaults.standard.object(forKey: "lastDailyCheckIn") as? Date
        
        if let lastDate = lastCheckInDate {
            // Check if last check-in was today
            hasCheckedInToday = Calendar.current.isDateInToday(lastDate)
        } else {
            hasCheckedInToday = false
        }
    }
    
    // Perform daily check-in
    func performDailyCheckIn() {
        guard !hasCheckedInToday else { return }
        
        // Add XP for daily check-in
        addXP(25)
        
        // Record check-in time
        UserDefaults.standard.set(Date(), forKey: "lastDailyCheckIn")
        hasCheckedInToday = true
    }
    
    // Check and update streak
    func checkAndUpdateStreak() {
        user = dataManager.checkAndUpdateStreak()
    }
    
    // Add XP to user with level-up logic
    func addXP(_ amount: Int) {
        print("Before adding XP: \(user.currentXP)/\(user.maxXP)")
        
        // Get updated user with new XP
        var updatedUser = dataManager.addXP(amount)
        
        // Check if user should level up (currentXP >= maxXP)
        if updatedUser.currentXP >= updatedUser.maxXP {
            // Calculate overflow XP
            let overflowXP = updatedUser.currentXP - updatedUser.maxXP
            
            // Increase max XP for next level (by 20%)
            let newMaxXP = Int(Double(updatedUser.maxXP) * 1.2)
            
            // Reset current XP to overflow amount
            updatedUser.currentXP = overflowXP
            updatedUser.maxXP = newMaxXP
            
            // Save the updated user
            updatedUser = dataManager.updateUser(updatedUser)
            
            print("Level up! New XP: \(updatedUser.currentXP)/\(updatedUser.maxXP)")
        }
        
        // Update the published user property
        user = updatedUser
        print("After adding XP: \(user.currentXP)/\(user.maxXP)")
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
    func updateUserStats(streakDays: Int, currentXP: Int, maxXP: Int? = nil) {
        // Calculate total hours based on streak days
        let totalHours = streakDays * 24
        
        // Use provided maxXP or keep existing
        let newMaxXP = maxXP ?? user.maxXP
        
        user = dataManager.updateUserStats(
            streakDays: streakDays, 
            totalHours: totalHours, 
            currentXP: currentXP,
            maxXP: newMaxXP
        )
    }
    
    // Apply a preset profile
    func applyPresetProfile(days: Int, xp: Int, maxXP: Int = 100) {
        updateUserStats(streakDays: days, currentXP: xp, maxXP: maxXP)
    }
    
    // Get rank for a specific number of streak days and XP
    func getRankForDaysAndXP(days: Int, xp: Int) -> String {
        return rankService.getFullRank(days: days, xp: xp)
    }
} 