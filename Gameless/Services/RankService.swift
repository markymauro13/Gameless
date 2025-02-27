import Foundation

class RankService {
    static let shared = RankService()
    
    private init() {}
    
    // Rank tiers
    private let rankTiers = [
        "Novice",
        "Adventurer",
        "Explorer",
        "Master",
        "Legend"
    ]
    
    // Roman numerals for ranks
    private let romanNumerals = ["I", "II", "III", "IV", "V"]
    
    // Get rank based on streak days
    func getRankForDays(_ days: Int) -> String {
        let tier: Int
        
        switch days {
        case 0:
            tier = 0 // Novice (starting level)
        case 1...7:
            tier = 0 // Novice
        case 8...30:
            tier = 1 // Adventurer
        case 31...90:
            tier = 2 // Explorer
        case 91...180:
            tier = 3 // Master
        default:
            tier = 4 // Legend
        }
        
        return rankTiers[tier]
    }
    
    // Get rank based on XP
    func getRankForXP(_ xp: Int) -> String {
        // XP ranges: 0-19, 20-39, 40-59, 60-79, 80-100
        let level: Int
        
        switch xp {
        case 0..<20:
            level = 0 // I
        case 20..<40:
            level = 1 // II
        case 40..<60:
            level = 2 // III
        case 60..<80:
            level = 3 // IV
        default:
            level = 4 // V
        }
        
        return "Novice \(romanNumerals[level])"
    }
    
    // Get full rank (combines tier from streak days and level from XP)
    func getFullRank(days: Int, xp: Int) -> String {
        let tier = getRankForDays(days)
        
        // If Legend tier, no need for roman numerals
        if tier == "Legend" {
            return tier
        }
        
        // XP ranges: 0-19, 20-39, 40-59, 60-79, 80-100
        let level: Int
        
        switch xp {
        case 0..<20:
            level = 0 // I
        case 20..<40:
            level = 1 // II
        case 40..<60:
            level = 2 // III
        case 60..<80:
            level = 3 // IV
        default:
            level = 4 // V
        }
        
        return "\(tier) \(romanNumerals[level])"
    }
} 