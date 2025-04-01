import Foundation

class GamelessDataManager {
    static let shared = GamelessDataManager()
    
    private let userDefaultsKey = "gamelessUserData"
    
    private init() {}
    
    // Load user data from UserDefaults
    func loadUser() -> User {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            return user
        } else {
            // Return default user if no data exists
            return User(
                streakDays: 0,
                totalHours: 0,
                currentXP: 0,
                maxXP: 100,
                recentXPGained: 0,
                rank: "Novice",
                gamingLimitHours: 1.0,
                selectedGoal: "Reduce gaming time"
            )
        }
    }
    
    // Save user data to UserDefaults
    private func saveUser(_ user: User) -> User {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
        return user
    }
    
    // Check and update streak based on last login
    func checkAndUpdateStreak() -> User {
        var user = loadUser()
        
        // Get the current date components
        let calendar = Calendar.current
        let now = Date()
        let today = calendar.startOfDay(for: now)
        
        // Get the last login date from UserDefaults
        let lastLoginKey = "lastLoginDate"
        let lastLogin: Date
        
        if let savedDate = UserDefaults.standard.object(forKey: lastLoginKey) as? Date {
            lastLogin = calendar.startOfDay(for: savedDate)
        } else {
            // First time login
            lastLogin = today
            UserDefaults.standard.set(today, forKey: lastLoginKey)
            return saveUser(user)
        }
        
        // Calculate days between last login and today
        if let daysBetween = calendar.dateComponents([.day], from: lastLogin, to: today).day {
            if daysBetween == 1 {
                // Consecutive day, increment streak
                user.streakDays += 1
                user.totalHours = user.streakDays * 24
                
                // Add XP for maintaining streak
                user.currentXP += 5
                user.recentXPGained = 5
                
                // Update rank
                user.rank = RankService.shared.getFullRank(days: user.streakDays, xp: user.currentXP)
            } else if daysBetween > 1 {
                // Streak broken, reset to 1
                user.streakDays = 1
                user.totalHours = 24
                user.recentXPGained = 0
                
                // Update rank
                user.rank = RankService.shared.getFullRank(days: user.streakDays, xp: user.currentXP)
            }
            
            // Update last login date
            UserDefaults.standard.set(today, forKey: lastLoginKey)
        }
        
        return saveUser(user)
    }
    
    // Add XP to user
    func addXP(_ amount: Int) -> User {
        var user = loadUser()
        user.currentXP += amount
        user.recentXPGained = amount
        
        // Update rank
        user.rank = RankService.shared.getFullRank(days: user.streakDays, xp: user.currentXP)
        
        return saveUser(user)
    }
    
    // Update user with new values (for level-up)
    func updateUser(_ user: User) -> User {
        return saveUser(user)
    }
    
    // Reset streak (for testing or if user relapses)
    func resetStreak() -> User {
        var user = loadUser()
        user.streakDays = 0
        user.totalHours = 0
        user.currentXP = 0
        user.recentXPGained = 0
        
        // Update rank
        user.rank = RankService.shared.getFullRank(days: user.streakDays, xp: user.currentXP)
        
        return saveUser(user)
    }
    
    // Update gaming limit
    func updateGamingLimit(_ limit: Double) -> User {
        var user = loadUser()
        user.gamingLimitHours = limit
        return saveUser(user)
    }
    
    // Update selected goal
    func updateSelectedGoal(_ goal: String) -> User {
        var user = loadUser()
        user.selectedGoal = goal
        return saveUser(user)
    }
    
    // Update user stats (for development purposes)
    func updateUserStats(streakDays: Int, totalHours: Int, currentXP: Int, maxXP: Int) -> User {
        var user = loadUser()
        user.streakDays = streakDays
        user.totalHours = totalHours
        user.currentXP = currentXP
        user.maxXP = maxXP
        
        // Update rank
        user.rank = RankService.shared.getFullRank(days: user.streakDays, xp: user.currentXP)
        
        return saveUser(user)
    }
} 