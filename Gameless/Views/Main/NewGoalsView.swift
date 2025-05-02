import SwiftUI

struct NewGoalsView: View {
    // Use @StateObject to create and own the ViewModel instance
    @StateObject private var viewModel = GoalsViewModel()
    @State private var showingAddGoal: Bool = false
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.2),
                    Color(red: 0.1, green: 0.05, blue: 0.25),
                    Color(red: 0.15, green: 0.05, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Goals & Habits")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Combined Goals Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Goals") // Simplified header
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                showingAddGoal = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.goals.isEmpty {
                            VStack(spacing: 10) {
                                Text("No goals yet")
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text("Tap + to add your first goal")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                        } else {
                            VStack(spacing: 5) {
                                ForEach(viewModel.goals) { goal in
                                    GoalRow(
                                        goal: goal,
                                        toggleAction: viewModel.toggleGoal,
                                        deleteAction: viewModel.deleteGoal
                                    )
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView(viewModel: viewModel, isPresented: $showingAddGoal)
        }
    }
}

// Keep GoalRow in this file since you don't want it as a separate file
struct GoalRow: View {
    let goal: Goal
    let toggleAction: (Goal) -> Void
    let deleteAction: (Goal) -> Void
    
    var body: some View {
        Button(action: {
            toggleAction(goal)
        }) {
            HStack {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(goal.isCompleted ? .green : .white)
                    .font(.title3)
                
                Text(goal.title)
                    .strikethrough(goal.isCompleted)
                    .foregroundColor(goal.isCompleted ? .white.opacity(0.6) : .white)
                
                Spacer()
                
                // Add icon for recurring goals
                if goal.isRecurring {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                deleteAction(goal)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .contextMenu {
            Button(role: .destructive) {
                deleteAction(goal)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct NewGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a ViewModel with sample data
        let previewViewModel = GoalsViewModel(goals: [
            Goal(title: "Go for a 30-minute walk", isCompleted: true, isRecurring: true),
            Goal(title: "Read for 20 minutes", isCompleted: false, isRecurring: true),
            Goal(title: "Plan weekend trip", isCompleted: false, isRecurring: false),
            Goal(title: "Complete a coding project", isCompleted: false, isRecurring: false)
        ])
        
        // Create the view with the ViewModel
        return NewGoalsView()
    }
}
