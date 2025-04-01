import SwiftUI

struct LimitLoggerView: View {
    // State variables
    @State private var showingAddSession = false
    @State private var showingLimitEditor = false
    @State private var sessionDate = Date()
    @State private var sessionHours = 1.0
    @State private var sessionMinutes = 0
    @State private var sessionGame = ""
    @State private var sessionNotes = ""
    @State private var newGamingLimit: Double = 1.0
    
    // Use ObservableObject for session management
    @StateObject private var viewModel = LimitLoggerViewModel()
    
    // User's daily limit from data manager
    @AppStorage("gamingLimit") private var gamingLimit: Double = 1.0
    
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
            
            VStack(spacing: 20) {
                // Header
                Text("Limit Logger")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // Daily limit card
                VStack(spacing: 10) {
                    Text("Your Daily Limit")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(Int(gamingLimit)) hour\(gamingLimit == 1 ? "" : "s")")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        newGamingLimit = gamingLimit // Initialize with current value
                        showingLimitEditor = true
                    }) {
                        Text("Change Limit")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.white.opacity(0.05))
                                        .background(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    ),
                                                    lineWidth: 1
                                                )
                                        )
                                        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                )
                .padding(.horizontal, 20)
                
                // Today's usage
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Usage")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    let todayUsage = viewModel.calculateTodayUsage()
                    let percentage = min(Double(todayUsage) / (gamingLimit * 60), 1.0)
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: geometry.size.width, height: 12)
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.2))
                            
                            // Progress fill
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: CGFloat(percentage) * geometry.size.width, height: 12)
                                .foregroundColor(percentage > 0.9 ? .red : (percentage > 0.7 ? .orange : Color.blue))
                        }
                    }
                    .frame(height: 12)
                    .padding(.horizontal, 20)
                    
                    // Usage text
                    HStack {
                        Text("\(viewModel.formatMinutes(todayUsage))")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(viewModel.formatMinutes(Int(gamingLimit * 60)))")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 20)
                }
                
                // Recent sessions
                VStack(alignment: .leading, spacing: 10) {
                    Text("Recent Sessions")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    if viewModel.gamingSessions.isEmpty {
                        VStack {
                            Image(systemName: "gamecontroller")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .padding(.bottom, 10)
                            
                            Text("No gaming sessions recorded yet")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 30)
                        .frame(maxWidth: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.gamingSessions) { session in
                                    SessionRow(session: session)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                Spacer()
                
                // Add session button
                Button(action: {
                    showingAddSession = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        Text("Log Gaming Session")
                            .fontWeight(.semibold)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingAddSession) {
            AddSessionView(
                isPresented: $showingAddSession,
                viewModel: viewModel
            )
        }
        .sheet(isPresented: $showingLimitEditor) {
            LimitEditorView(
                isPresented: $showingLimitEditor,
                currentLimit: gamingLimit,
                newLimit: $newGamingLimit,
                onSave: {
                    gamingLimit = newGamingLimit
                    viewModel.updateGamingLimit(newGamingLimit)
                }
            )
        }
        .onAppear {
            // Load saved sessions
            viewModel.loadSessions()
        }
    }
}

// Model for a gaming session
struct GamingSession: Identifiable, Codable {
    var id: UUID
    var date: Date
    var durationMinutes: Int
    var game: String
    var notes: String
}

// Row view for a single session
struct SessionRow: View {
    let session: GamingSession
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.game.isEmpty ? "Unnamed Game" : session.game)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(formatDate(session.date))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(formatDuration(session.durationMinutes))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.green.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(12)
        .background(Color(red: 0.1, green: 0.1, blue: 0.2))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        if hours > 0 {
            return "\(hours)h \(mins)m"
        } else {
            return "\(mins)m"
        }
    }
}

struct LimitLoggerView_Previews: PreviewProvider {
    static var previews: some View {
        LimitLoggerView()
    }
}
