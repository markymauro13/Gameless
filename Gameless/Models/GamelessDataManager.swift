import Foundation

class GamelessDataManager {
    private let userDefaultsKey = "gamelessUserData"
    private let rankService: RankService
    
    // Singleton instance
    static let shared = GamelessDataManager()
    
    private init(rankService: RankService = RankService.shared) {
        self.rankService = rankService
    }
    
    // Save user data
    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Load user data
    func loadUser() -> User {
        if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
            // Update rank based on streak days and XP
            var user = decodedUser
            user.rank = rankService.getFullRank(days: user.streakDays, xp: user.currentXP)
            return user
        }
        
        // Return default user if no saved data exists
        return User(rank: rankService.getFullRank(days: 0, xp: 0))
    }
    
    // Check and update streak
    func checkAndUpdateStreak() -> User {
        var user = loadUser()
        let calendar = Calendar.current
        let today = Date()
        
        // Check if a day has passed since last check-in
        if !calendar.isDate(user.lastCheckInDate, inSameDayAs: today) {
            // Update streak days
            user.streakDays += 1
            
            // Update total hours (24 hours per day)
            user.totalHours = user.streakDays * 24
            
            // Add XP for maintaining streak
            user.currentXP += 20
            if user.currentXP > user.maxXP {
                user.currentXP = user.maxXP
            }
            user.recentXPGained = 20
            
            // Update last check-in date
            user.lastCheckInDate = today
            
            // Update rank
            user.rank = rankService.getFullRank(days: user.streakDays, xp: user.currentXP)
            
            // Save updated user
            saveUser(user)
        }
        
        return user
    }
    
    // Reset user streak
    func resetStreak() -> User {
        var user = loadUser()
        
        user.streakDays = 0
        user.totalHours = 0
        user.currentXP = 0
        user.streakStartDate = Date()
        user.lastCheckInDate = Date()
        user.rank = rankService.getFullRank(days: 0, xp: 0)
        
        saveUser(user)
        return user
    }
    
    // Add XP to user
    func addXP(_ amount: Int) -> User {
        var user = loadUser()
        
        // Add XP and cap at maxXP
        let newXP = user.currentXP + amount
        user.currentXP = min(newXP, user.maxXP)
        user.recentXPGained = amount
        
        // Update rank based on new XP
        user.rank = rankService.getFullRank(days: user.streakDays, xp: user.currentXP)
        
        saveUser(user)
        return user
    }
    
    // Update gaming limit
    func updateGamingLimit(_ limit: Double) -> User {
        var user = loadUser()
        user.gamingLimit = limit
        saveUser(user)
        return user
    }
    
    // Update selected goal
    func updateSelectedGoal(_ goal: String) -> User {
        var user = loadUser()
        user.selectedGoal = goal
        saveUser(user)
        return user
    }
    
    // Update user stats (for development purposes)
    func updateUserStats(streakDays: Int, totalHours: Int, currentXP: Int) -> User {
        var user = loadUser()
        user.streakDays = streakDays
        user.totalHours = totalHours
        user.currentXP = min(currentXP, user.maxXP)
        user.rank = rankService.getFullRank(days: streakDays, xp: user.currentXP)
        
        saveUser(user)
        return user
    }
} 