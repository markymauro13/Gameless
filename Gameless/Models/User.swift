import Foundation

struct User: Codable {
    var streakDays: Int
    var totalHours: Int
    var currentXP: Int
    var maxXP: Int
    var recentXPGained: Int
    var rank: String
    var gamingLimitHours: Double
    var selectedGoal: String
    
    // Initialize with default values
    init(streakDays: Int = 0,
         totalHours: Int = 0,
         currentXP: Int = 0,
         maxXP: Int = 100,
         recentXPGained: Int = 0,
         rank: String = "Novice I",
         gamingLimitHours: Double = 1.0,
         selectedGoal: String = "Reduce gaming time") {
        
        self.streakDays = streakDays
        self.totalHours = totalHours
        self.currentXP = currentXP
        self.maxXP = maxXP
        self.recentXPGained = recentXPGained
        self.rank = rank
        self.gamingLimitHours = gamingLimitHours
        self.selectedGoal = selectedGoal
    }
} 