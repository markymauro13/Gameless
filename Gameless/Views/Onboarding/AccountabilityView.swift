import SwiftUI

struct AccountabilityView: View {
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Gameless")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("Stay accountable.")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Gameless helps you track gaming habits and build healthier routines.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.blue)
                        Text("Self Reporting")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.blue)
                        Text("Streaks")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(.blue)
                        Text("Goal tracking")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                .cornerRadius(10)
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
            }
            .padding()
        }
    }
}

struct AccountabilityView_Previews: PreviewProvider {
    static var previews: some View {
        AccountabilityView(onContinue: {})
    }
} 