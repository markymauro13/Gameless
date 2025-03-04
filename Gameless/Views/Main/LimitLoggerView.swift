import SwiftUI

struct LimitLoggerView: View {
    // State variables
    @State private var showingAddSession = false
    @State private var sessionDate = Date()
    @State private var sessionHours = 1.0
    @State private var sessionMinutes = 0
    @State private var sessionGame = ""
    @State private var sessionNotes = ""
    
    // Sample data - would be replaced with actual data storage
    @State private var gamingSessions: [GamingSession] = []
    
    // User's daily limit (would be loaded from UserDefaults in a real app)
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
                        // Would open a limit editor
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
                    
                    let todayUsage = calculateTodayUsage()
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
                        Text("\(formatMinutes(todayUsage))")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(formatMinutes(Int(gamingLimit * 60)))")
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
                    
                    if gamingSessions.isEmpty {
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
                                ForEach(gamingSessions) { session in
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
                    .foregroundColor(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingAddSession) {
            AddSessionView(
                isPresented: $showingAddSession,
                date: $sessionDate,
                hours: $sessionHours,
                minutes: $sessionMinutes,
                game: $sessionGame,
                notes: $sessionNotes,
                onSave: saveSession
            )
        }
        .onAppear {
            // Load saved sessions
            loadSessions()
        }
    }
    
    // Calculate today's usage in minutes
    private func calculateTodayUsage() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return gamingSessions
            .filter { calendar.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.durationMinutes }
    }
    
    // Format minutes as "X hr Y min"
    private func formatMinutes(_ minutes: Int) -> String {
        let hours = minutes / 60
        let mins = minutes % 60
        
        if hours > 0 {
            return "\(hours) hr \(mins) min"
        } else {
            return "\(mins) min"
        }
    }
    
    // Save a new gaming session
    private func saveSession() {
        let totalMinutes = Int(sessionHours * 60) + sessionMinutes
        
        let newSession = GamingSession(
            id: UUID(),
            date: sessionDate,
            durationMinutes: totalMinutes,
            game: sessionGame,
            notes: sessionNotes
        )
        
        gamingSessions.append(newSession)
        gamingSessions.sort { $0.date > $1.date } // Sort by most recent
        
        // Reset form
        sessionDate = Date()
        sessionHours = 1.0
        sessionMinutes = 0
        sessionGame = ""
        sessionNotes = ""
        
        // Save to persistent storage (would implement with UserDefaults or CoreData)
        saveSessions()
    }
    
    // Load sessions from storage
    private func loadSessions() {
        // In a real app, this would load from UserDefaults or CoreData
        // For now, we'll just use sample data
        if gamingSessions.isEmpty {
            let calendar = Calendar.current
            let today = Date()
            let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
            
            gamingSessions = [
                GamingSession(
                    id: UUID(),
                    date: today,
                    durationMinutes: 45,
                    game: "Fortnite",
                    notes: "Quick match with friends"
                ),
                GamingSession(
                    id: UUID(),
                    date: yesterday,
                    durationMinutes: 90,
                    game: "Minecraft",
                    notes: "Building project"
                )
            ]
        }
    }
    
    // Save sessions to storage
    private func saveSessions() {
        // In a real app, this would save to UserDefaults or CoreData
        // For now, we'll just print to console
        print("Saved \(gamingSessions.count) sessions")
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

// Add session view
struct AddSessionView: View {
    @Binding var isPresented: Bool
    @Binding var date: Date
    @Binding var hours: Double
    @Binding var minutes: Int
    @Binding var game: String
    @Binding var notes: String
    var onSave: () -> Void
    
    @State private var selectedTab = 0
    @FocusState private var isGameFieldFocused: Bool
    @FocusState private var isNotesFieldFocused: Bool
    
    // Popular games for quick selection
    let popularGames = [
        "Fortnite", "Minecraft", "Call of Duty", "League of Legends",
        "Valorant", "Apex Legends", "Roblox", "GTA V",
        "FIFA", "Overwatch", "Dota 2", "CS:GO"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.15)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Date picker
                    DatePicker("Session Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .foregroundColor(.white)
                        .accentColor(.blue)
                        .padding(.horizontal, 20)
                    
                    // Duration picker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Duration")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack {
                            // Hours
                            VStack {
                                Text("\(Int(hours)) hour\(hours == 1 ? "" : "s")")
                                    .foregroundColor(.white)
                                
                                Slider(value: $hours, in: 0...8, step: 1)
                                    .accentColor(.blue)
                            }
                            
                            // Minutes
                            VStack {
                                Text("\(minutes) minute\(minutes == 1 ? "" : "s")")
                                    .foregroundColor(.white)
                                
                                Picker("Minutes", selection: $minutes) {
                                    ForEach(0..<60) { minute in
                                        if minute % 5 == 0 {
                                            Text("\(minute)").tag(minute)
                                        }
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                                .clipped()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Game selection
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Game")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextField("Game name", text: $game)
                            .padding()
                            .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .focused($isGameFieldFocused)
                        
                        // Popular games
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(popularGames, id: \.self) { gameName in
                                    Button(action: {
                                        game = gameName
                                    }) {
                                        Text(gameName)
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(game == gameName ? Color.blue : Color(red: 0.1, green: 0.1, blue: 0.2))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notes (Optional)")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .padding(4)
                            .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .focused($isNotesFieldFocused)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {
                        onSave()
                        isPresented = false
                    }) {
                        Text("Save Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.green]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .disabled(hours == 0 && minutes == 0) // Prevent empty durations
                }
                .navigationTitle("Log Gaming Session")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isPresented = false
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct LimitLoggerView_Previews: PreviewProvider {
    static var previews: some View {
        LimitLoggerView()
    }
}
