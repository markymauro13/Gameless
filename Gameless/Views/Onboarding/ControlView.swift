import SwiftUI

struct ControlView: View {
    var selectedGoal: String?
    var gamingLimit: Double
    var onFinish: () -> Void
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gameless")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("You're in control.")
                    .font(.title2)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Only you can level up your life. But, we can help.")
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    Text("Make sure to enable notifications to stay connected to your Gameless journey.")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: onFinish) {
                    Text("Finish Setup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(
            selectedGoal: "Learn skills",
            gamingLimit: 1.0,
            onFinish: {}
        )
    }
} 