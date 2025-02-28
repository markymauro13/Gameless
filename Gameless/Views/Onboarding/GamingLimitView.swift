import SwiftUI

struct GamingLimitView: View {
    @Binding var gamingLimit: Double
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
                
                Text("How Much Gaming Is Right for You?")
                    .font(.title2)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("\(gamingLimit == 1 ? "1 hr / day (Recommended)" : "\(Int(gamingLimit)) hrs / day")")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top)
                
                VStack(spacing: 10) {
                    Slider(value: $gamingLimit, in: 0...8, step: 1)
                        .accentColor(.blue)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("No Gaming")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("Gamer")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
                .padding()
                
                Spacer()
                
                Button(action: onContinue) {
                    Text("Set Limit")
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

struct GamingLimitView_Previews: PreviewProvider {
    static var previews: some View {
        GamingLimitView(gamingLimit: .constant(1.0), onContinue: {})
    }
} 