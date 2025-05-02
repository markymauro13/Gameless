import SwiftUI

struct AddGoalView: View {
    @ObservedObject var viewModel: GoalsViewModel
    @Binding var isPresented: Bool
    @State private var newGoalTitle: String = ""
    @State private var isRecurring: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
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
                
                VStack(spacing: 20) {
                    TextField("Enter your goal", text: $newGoalTitle)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Goal type picker
                    Picker("Goal Type", selection: $isRecurring) {
                        Text("Recurring").tag(true)
                        Text("One-time").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .colorMultiply(.white)
                    
                    HStack {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button("Add") {
                            viewModel.addGoal(title: newGoalTitle, isRecurring: isRecurring)
                            isPresented = false
                        }
                        .foregroundColor(.white)
                        .disabled(newGoalTitle.isEmpty)
                        .opacity(newGoalTitle.isEmpty ? 0.6 : 1)
                    }
                    .padding()
                    
                    Spacer()
                }
                .navigationTitle("Add Goal")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct AddGoalView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock ViewModel for preview
        let viewModel = GoalsViewModel()
        
        // Create a binding to a Bool for isPresented
        return AddGoalView(viewModel: viewModel, isPresented: .constant(true))
    }
} 