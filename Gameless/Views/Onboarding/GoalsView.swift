import SwiftUI

struct GoalsView: View {
    @Binding var selectedGoal: String?
    var onContinue: () -> Void
    
    // Goals options
    let goals = [
        "Reduce gaming time",
        "Quit gaming completely",
        "Learn skills",
        "Focus on health & fitness"
    ]
    
    // Goal icons
    let goalIcons = [
        "⏱️",
        "🚫",
        "📚",
        "🏋️"
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gameless")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("What brings you here?")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    ForEach(0..<goals.count, id: \.self) { index in
                        Button(action: {
                            selectedGoal = goals[index]
                        }) {
                            HStack {
                                Text(goalIcons[index])
                                    .font(.title2)
                                    .padding(.trailing, 5)
                                
                                Text(goals[index])
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                if selectedGoal == goals[index] {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                } else {
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding()
                            .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: onContinue) {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
                .disabled(selectedGoal == nil)
                .opacity(selectedGoal == nil ? 0.5 : 1)
            }
            .padding()
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView(selectedGoal: .constant("Learn skills"), onContinue: {})
    }
} 