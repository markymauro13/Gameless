import Foundation
import SwiftUI

class RecoveryViewModel: ObservableObject {
    @Published var streakDays: Int = 0
    @Published var currentPhaseTitle: String = ""
    @Published var currentPhaseDescription: String = ""
    @Published var currentTips: [String] = []
    @Published var currentBenefits: [String] = []
    @Published var nextMilestone: Int? = nil
    
    private let dataManager = GamelessDataManager.shared
    
    // Recovery phases information
    private let phases: [(range: Range<Int>, title: String, description: String)] = [
        (0..<7, "Initial Withdrawal", "You're in the early withdrawal phase. This is often the hardest part as your brain adjusts to the absence of gaming dopamine. Cravings may be intense, but they will gradually decrease."),
        (7..<30, "Adjustment Phase", "Your brain is beginning to adjust to life without gaming. You may experience mood swings and occasional cravings, but you're making significant progress."),
        (30..<60, "Recovery Phase", "You've made it to a major milestone! Your brain chemistry is rebalancing, and you're developing healthier habits and interests."),
        (60..<90, "Advanced Recovery", "You're in the advanced stages of recovery. Your brain has largely reset from gaming addiction, and you're building a sustainable gaming-free lifestyle."),
        (90..<Int.max, "Sustained Recovery", "Congratulations on reaching 90 days! You've completed the full brain reset. Your dopamine sensitivity has largely returned to normal, and you've broken the addiction cycle.")
    ]
    
    // Tips based on recovery phase
    private let phaseTips: [Range<Int>: [String]] = [
        0..<7: [
            "Stay busy with short, engaging activities to distract from cravings",
            "Remove gaming apps from your devices and unfollow gaming content",
            "Tell friends and family about your goal for accountability",
            "Practice deep breathing when cravings hit (4 seconds in, hold 4, out 4)",
            "Drink plenty of water and prioritize sleep to help your body adjust"
        ],
        7..<30: [
            "Start a new hobby that uses your hands (drawing, crafting, cooking)",
            "Exercise daily - even a 20-minute walk helps regulate dopamine",
            "Keep a journal of triggers and how you overcome them",
            "Celebrate each week milestone with a small non-gaming reward",
            "Join a support group of others limiting gaming like r/STOPgaming"
        ],
        30..<60: [
            "Reflect on improvements you've noticed since quitting gaming",
            "Develop a consistent daily routine to provide structure",
            "Try meditation to improve focus and reduce stress",
            "Reconnect with friends outside of gaming contexts",
            "Challenge yourself with learning a new skill or language"
        ],
        60..<90: [
            "Share your experience to help others on their recovery journey",
            "Develop a plan for how you'll handle gaming in the future",
            "Focus on building meaningful long-term projects",
            "Practice mindfulness to stay present and engaged with life",
            "Consider how to use your reclaimed time for personal growth"
        ],
        90..<Int.max: [
            "Reflect on your 90-day journey and what you've learned",
            "Consider if moderate, controlled gaming could be part of your life",
            "Continue building on the healthy habits you've developed",
            "Help others who are struggling with gaming addiction",
            "Set new goals that align with your values and interests"
        ]
    ]
    
    // Benefits based on recovery phase
    private let phaseBenefits: [Range<Int>: [String]] = [
        0..<7: [
            "Increased awareness of your gaming habits",
            "More free time in your day",
            "First steps toward dopamine rebalancing"
        ],
        7..<30: [
            "Improved sleep quality",
            "Better focus and attention span",
            "Reduced anxiety and irritability",
            "More energy for other activities"
        ],
        30..<60: [
            "Significantly improved dopamine sensitivity",
            "Better emotional regulation",
            "Increased productivity",
            "Improved relationships",
            "Greater enjoyment from simple activities"
        ],
        60..<90: [
            "Near-complete dopamine rebalancing",
            "Sustained improvements in focus and productivity",
            "New hobbies and interests established",
            "Healthier relationship with technology",
            "Improved self-esteem and confidence"
        ],
        90..<Int.max: [
            "Complete brain reset from gaming addiction",
            "Natural dopamine response restored",
            "Sustainable gaming-free lifestyle established",
            "Improved overall mental health",
            "Greater life satisfaction and purpose"
        ]
    ]
    
    // Milestone days
    private let milestones = [7, 30, 60, 90]
    
    func loadUserData() {
        let user = dataManager.loadUser()
        streakDays = user.streakDays
        
        updatePhaseInfo()
        updateNextMilestone()
    }
    
    private func updatePhaseInfo() {
        // Find current phase
        if let currentPhase = phases.first(where: { $0.range.contains(streakDays) }) {
            currentPhaseTitle = currentPhase.title
            currentPhaseDescription = currentPhase.description
            
            // Get tips and benefits for current phase
            for (range, tips) in phaseTips {
                if range.contains(streakDays) {
                    currentTips = tips
                    break
                }
            }
            
            for (range, benefits) in phaseBenefits {
                if range.contains(streakDays) {
                    currentBenefits = benefits
                    break
                }
            }
        }
    }
    
    private func updateNextMilestone() {
        nextMilestone = milestones.first { $0 > streakDays }
    }
} 