import SwiftUI

struct AddSessionView: View {
    @Binding var isPresented: Bool
    let viewModel: LimitLoggerViewModel
    
    @State private var date: Date = Date()
    @State private var hours: Double = 1.0
    @State private var minutes: Int = 0
    @State private var game: String = ""
    @State private var notes: String = ""
    
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
                        viewModel.saveSession(
                            date: date,
                            hours: hours,
                            minutes: minutes,
                            game: game,
                            notes: notes
                        )
                        isPresented = false
                    }) {
                        Text("Save Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
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

struct AddSessionView_Previews: PreviewProvider {
    static var previews: some View {
        AddSessionView(
            isPresented: .constant(true),
            viewModel: LimitLoggerViewModel()
        )
    }
} 
