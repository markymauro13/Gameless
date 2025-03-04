import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.15)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .bold()
                
                Spacer()
                
                Text("Coming soon")
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
