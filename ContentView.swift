import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            WelcomeView()
                .navigationBarHidden(true)
        }
    }
}

@main
struct MindfulMentorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


