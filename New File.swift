import SwiftUI

struct WelcomeView: View {
    @State private var isAnimating = false
    @State private var floatState = false
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(gradient: Gradient(colors: [.purple, .blue, .pink]), 
                           startPoint: .topLeading, 
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .hueRotation(.degrees(isAnimating ? 45 : 0))
            .animation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: true), 
                       value: isAnimating)
            
            // Floating circles
            ForEach(0..<15) { index in
                Circle()
                    .frame(width: CGFloat.random(in: 20...100), 
                           height: CGFloat.random(in: 20...100))
                    .foregroundColor([Color.orange, .yellow, .white, .pink].randomElement()!)
                    .opacity(0.2)
                    .offset(x: CGFloat.random(in: -200...200), 
                            y: floatState ? CGFloat.random(in: -200...200) : CGFloat.random(in: -200...200))
                    .animation(Animation.easeInOut(duration: Double.random(in: 3...6)).repeatForever(), 
                               value: floatState)
            }
            
            // Main content
            VStack(spacing: 20) {
                // Title with parallax effect
                Text("Mindful Mentor 🌱")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundLinearGradient(colors: [.white, .yellow], startPoint: .leading, endPoint: .trailing)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
                    .rotation3DEffect(
                        .degrees(Double(dragOffset.width / 20)),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .offset(x: dragOffset.width / 10, y: dragOffset.height / 10)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnimating)
                
                // Subtitle with typewriter effect
                Text("Your AI-powered guide to better mental well-being")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(
                        Animation.easeOut(duration: 1).delay(0.5),
                        value: isAnimating
                    )
                    .mask(
                        Rectangle()
                            .scale(x: isAnimating ? 1 : 0, anchor: .leading)
                            .animation(.easeInOut(duration: 1).delay(0.3))
                    )
                
                // Get Started button
                NavigationLink(destination: QuestionnaireView()) {
                    HStack {
                        Text("Get Started")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                        Image(systemName: "arrow.forward.circle")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(LinearGradient(gradient: Gradient(colors: [.white, .clear]), 
                                                   startPoint: .topLeading, 
                                                   endPoint: .bottomTrailing), 
                                    lineWidth: 2)
                    )
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(1), value: isAnimating)
                }
            }
            .padding(30)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            dragOffset = .zero
                        }
                    }
            )
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isAnimating = true
                floatState.toggle()
            }
        }
    }
}

// Extension for gradient text
extension View {
    func foregroundLinearGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
        .mask(self)
    }
}
