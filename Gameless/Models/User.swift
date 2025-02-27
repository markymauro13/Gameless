import Foundation

struct User: Codable {
    var id: String
    var streakDays: Int
    var totalHours: Int
    var currentXP: Int
    var maxXP: Int
    var recentXPGained: Int
    var gamingLimit: Double
    var selectedGoal: String
    var streakStartDate: Date
    var lastCheckInDate: Date
    var rank: String
    
    // Initialize with default values
    init(id: String = UUID().uuidString,
         streakDays: Int = 0,
         totalHours: Int = 0,
         currentXP: Int = 0,
         maxXP: Int = 100,
         recentXPGained: Int = 0,
         gamingLimit: Double = 1.0,
         selectedGoal: String = "Reduce gaming time",
         streakStartDate: Date = Date(),
         lastCheckInDate: Date = Date(),
         rank: String = "Novice I") {
        
        self.id = id
        self.streakDays = streakDays
        self.totalHours = totalHours
        self.currentXP = currentXP
        self.maxXP = maxXP
        self.recentXPGained = recentXPGained
        self.gamingLimit = gamingLimit
        self.selectedGoal = selectedGoal
        self.streakStartDate = streakStartDate
        self.lastCheckInDate = lastCheckInDate
        self.rank = rank
    }
} 