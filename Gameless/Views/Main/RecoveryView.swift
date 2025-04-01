import SwiftUI

struct RecoveryView: View {
    @StateObject private var viewModel = RecoveryViewModel()
    @State private var animateProgress = false
    
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
                VStack(spacing: 25) {
                    // Header
                    Text("Your Recovery Journey")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Progress circle
                    ZStack {
                        // Background circle
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.3)
                            .foregroundColor(Color.gray)
                        
                        // Progress circle
                        Circle()
                            .trim(from: 0.0, to: animateProgress ? min(CGFloat(viewModel.streakDays) / 90.0, 1.0) : 0)
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple, .pink]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.easeInOut(duration: 1.5), value: animateProgress)
                        
                        // Center content
                        VStack(spacing: 5) {
                            Text("\(viewModel.streakDays)")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("DAYS")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text("of 90")
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.top, 5)
                        }
                    }
                    .frame(width: 250, height: 250)
                    .padding(.vertical, 20)
                    
                    // Milestone indicators
                    HStack(spacing: 0) {
                        ForEach([7, 30, 60, 90], id: \.self) { milestone in
                            VStack(spacing: 8) {
                                Circle()
                                    .fill(viewModel.streakDays >= milestone ? Color.green : Color.gray.opacity(0.3))
                                    .frame(width: 20, height: 20)
                                
                                Text("\(milestone)")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(viewModel.streakDays >= milestone ? .white : .gray)
                                
                                Text("days")
                                    .font(.system(size: 12))
                                    .foregroundColor(viewModel.streakDays >= milestone ? .white.opacity(0.7) : .gray.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)
                    
                    // Current phase card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text(viewModel.currentPhaseTitle)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("Day \(viewModel.streakDays)")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(20)
                        }
                        
                        Text(viewModel.currentPhaseDescription)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if let nextMilestone = viewModel.nextMilestone {
                            HStack {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.green)
                                
                                Text("Next milestone: \(nextMilestone) days")
                                    .font(.subheadline)
                                    .foregroundColor(.green)
                            }
                            .padding(.top, 5)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    // Recovery tips
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Recovery Tips")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.currentTips, id: \.self) { tip in
                            HStack(alignment: .top, spacing: 15) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 18))
                                
                                Text(tip)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    // Benefits gained
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Benefits You've Gained")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        ForEach(viewModel.currentBenefits, id: \.self) { benefit in
                            HStack(spacing: 15) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 18))
                                
                                Text(benefit)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.05))
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 30)
                }
            }
        }
        .onAppear {
            viewModel.loadUserData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateProgress = true
            }
        }
    }
}

struct RecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryView()
    }
}
