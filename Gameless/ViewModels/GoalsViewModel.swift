import SwiftUI
import Combine

class GoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    
    // Initializer allows passing initial data (useful for previews or loading)
    init(goals: [Goal] = []) {
        self.goals = goals
    }
    
    func addGoal(title: String, isRecurring: Bool) {
        guard !title.isEmpty else { return }
        let newGoal = Goal(title: title, isRecurring: isRecurring)
        goals.append(newGoal)
    }
    
    func toggleGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].isCompleted.toggle()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }
    
    func deleteGoals(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
    }
    
    // You could add persistence methods here
    // func saveGoals() { ... }
    // func loadGoals() { ... }
} 