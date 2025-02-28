import SwiftUI

struct LandingView: View {
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40) {
                Spacer()
                
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color(red: 0.1, green: 0.1, blue: 0.3))
                            .frame(width: 150, height: 150)
                    )
                
                Text("Gameless")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                Text("helps you limit gaming, regain focus, and be more productive")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: onContinue) {
                    Text("Get Started")
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

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView(onContinue: {})
    }
} 