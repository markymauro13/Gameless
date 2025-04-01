import SwiftUI

struct LimitEditorView: View {
    @Binding var isPresented: Bool
    let currentLimit: Double
    @Binding var newLimit: Double
    var onSave: () -> Void
    
    @State private var sliderValue: Double
    
    init(isPresented: Binding<Bool>, currentLimit: Double, newLimit: Binding<Double>, onSave: @escaping () -> Void) {
        self._isPresented = isPresented
        self.currentLimit = currentLimit
        self._newLimit = newLimit
        self.onSave = onSave
        self._sliderValue = State(initialValue: newLimit.wrappedValue)
    }
    
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
                
                VStack(spacing: 30) {
                    // Current limit display
                    VStack(spacing: 5) {
                        Text("New Daily Limit")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(formattedDailyLimit)
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 20)
                    
                    // Slider for fine adjustment
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Adjust Limit")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Debug information
                        Text("Raw slider value: \(String(format: "%.2f", sliderValue))")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Slider(value: $sliderValue, in: 0.5...8, step: 0.5)
                            .accentColor(.blue)
                            .onChange(of: sliderValue) { oldValue, newValue in
                                newLimit = newValue
                                // Debug print
                                print("Slider changed: old=\(oldValue), new=\(newValue), int value=\(Int(newValue))")
                            }
                        
                        // Hour markers
                        HStack {
                            Text("30m")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("8h")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Preset buttons
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Presets")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Generate presets programmatically
                        let presets = generatePresets()
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                            ForEach(presets, id: \.value) { preset in
                                Button(action: {
                                    sliderValue = preset.value
                                    newLimit = preset.value
                                }) {
                                    Text(preset.label)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            // Highlight the button if it matches the current slider value
                                            abs(sliderValue - preset.value) < 0.01 ? 
                                                Color.blue : 
                                                Color(red: 0.1, green: 0.1, blue: 0.2)
                                        )
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Information about limits
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recommended Limits")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .font(.system(size: 18))
                            
                            Text("Health experts recommend limiting recreational screen time to 1-2 hours per day for optimal well-being.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color(red: 0.1, green: 0.1, blue: 0.2))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {
                        onSave()
                        isPresented = false
                    }) {
                        Text("Save Limit")
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
                .navigationTitle("Set Gaming Limit")
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
    
    // Computed property for formatted daily limit
    private var formattedDailyLimit: String {
        let totalHours = sliderValue
        let wholeHours = Int(totalHours)
        let minutes = Int((totalHours - Double(wholeHours)) * 60)
        
        if wholeHours == 0 {
            return "\(minutes) minutes"
        } else if minutes == 0 {
            return "\(wholeHours) hour\(wholeHours == 1 ? "" : "s")"
        } else {
            let hourText = "\(wholeHours) hour\(wholeHours == 1 ? "" : "s")"
            let minuteText = "\(minutes) min"
            return "\(hourText) \(minuteText)"
        }
    }
    
    // Helper method to generate presets programmatically
    private func generatePresets() -> [(label: String, value: Double)] {
        var presets: [(label: String, value: Double)] = []
        
        // Add 30 minutes preset
        presets.append(("30 min", 0.5))
        
        // Add hour presets from 1 to 4 hours
        for hour in 1...4 {
            let value = Double(hour)
            let label = hour == 1 ? "1 hour" : "\(hour) hours"
            presets.append((label, value))
        }
        
        return presets
    }
}

struct LimitEditorView_Previews: PreviewProvider {
    static var previews: some View {
        LimitEditorView(
            isPresented: .constant(true),
            currentLimit: 2.0,
            newLimit: .constant(2.0),
            onSave: {}
        )
    }
} 
