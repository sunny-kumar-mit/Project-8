import SwiftUI

struct QuestionnaireView: View {
    @State private var sleepHours: Double = 7
    @State private var stressLevel: Double = 5
    @State private var moodRating: Double = 5
    @State private var physicalActivity: Bool = false
    @State private var animateElements = false
    @State private var floatingState = false
    @State private var cardAppear = [false, false, false, false]
    
    // Shared animation configurations
    let gradient = LinearGradient(
        gradient: Gradient(colors: [.purple, .blue, .pink]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Constant range for floating particles
    let floatingParticles = Array(0..<20)
    
    var body: some View {
        ZStack {
            // Animated background
            gradient
                .ignoresSafeArea()
                .hueRotation(.degrees(animateElements ? 45 : 0))
                .animation(
                    Animation.easeInOut(duration: 4).repeatForever(autoreverses: true),
                    value: animateElements
                )
            
            // Floating particles
            ForEach(floatingParticles, id: \.self) { index in
                Circle()
                    .frame(width: CGFloat.random(in: 2...8))
                    .foregroundColor([.white, .yellow, .pink].randomElement()!)
                    .opacity(0.4)
                    .offset(
                        x: CGFloat.random(in: -200...200),
                        y: floatingState ? CGFloat.random(in: -200...200) : CGFloat.random(in: -200...200)
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 3...6)).repeatForever(),
                        value: floatingState
                    )
            }
            
            ScrollView {
                VStack(spacing: 10) {
                    // Sleep Quality Card
                    QuestionCard(
                        title: "1. Sleep Quality",
                        question: "How many hours of quality sleep did you get last night?",
                        value: $sleepHours,
                        range: 0...12,
                        step: 1,
                        icon: "moon.fill",
                        color: .blue,
                        delay: 0.2,
                        isVisible: cardAppear[0]
                    )
                    
                    // Work Stress Card
                    QuestionCard(
                        title: "2. Work Stress Level",
                        question: "On a scale from 1 (not stressed) to 10 (extremely stressed), how stressed did you feel at work today?",
                        value: $stressLevel,
                        range: 1...10,
                        step: 1,
                        icon: "cloud.fill",
                        color: .purple,
                        delay: 0.4,
                        isVisible: cardAppear[1]
                    )
                    
                    // Mood Card
                    QuestionCard(
                        title: "3. Overall Mood",
                        question: "How would you rate your overall mood today on a scale of 1 (very low) to 10 (very high)?",
                        value: $moodRating,
                        range: 1...10,
                        step: 1,
                        icon: "face.smiling",
                        color: .orange,
                        delay: 0.6,
                        isVisible: cardAppear[2]
                    )
                    
                    // Physical Activity Card
                    PhysicalActivityCard(
                        isActive: $physicalActivity,
                        delay: 0.8,
                        isVisible: cardAppear[3]
                    )
                    
                    // Animated Submit Button
                    NavigationLink(destination: ScoreView(sleepHours: sleepHours, stressLevel: stressLevel, moodRating: moodRating, physicalActivity: physicalActivity)) {
                        HStack {
                            Text("Calculate Your Score")
                                .font(.title3.weight(.bold))
                            Image(systemName: "chart.bar.fill")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white.opacity(0.5), .clear]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .scaleEffect(animateElements ? 1 : 0.9)
                        .opacity(animateElements ? 1 : 0)
                        .animation(.spring().delay(1.2), value: animateElements)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation(.spring()) {
                animateElements = true
                floatingState.toggle()
            }
            
            // Stagger card appearances
            for i in 0..<4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        cardAppear[i] = true
                    }
                }
            }
        }
    }
}

struct QuestionCard: View {
    let title: String
    let question: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let icon: String
    let color: Color
    let delay: Double
    let isVisible: Bool
    
    @State private var currentValue: Double = 0
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(color))
                    .scaleEffect(isVisible ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(delay), value: isVisible)
                
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                    .offset(x: isVisible ? 0 : 50)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(delay + 0.1), value: isVisible)
            }
            
            Text(question)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .offset(y: isVisible ? 0 : 20)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(delay + 0.2), value: isVisible)
            
            Slider(value: $value, in: range, step: step)
                .accentColor(color)
                .scaleEffect(isEditing ? 1.05 : 1)
                .animation(.spring(), value: isEditing)
                .onChange(of: value) { oldValue, newValue in
                    withAnimation(.spring()) {
                        isEditing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isEditing = false
                        }
                    }
                }
            
            Text("\(Int(value))")
                .font(.title2.weight(.bold))
                .foregroundColor(color)
                .scaleEffect(isEditing ? 1.2 : 1)
                .animation(.spring(), value: isEditing)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
        )
        .offset(x: isVisible ? 0 : -UIScreen.main.bounds.width)
        .rotation3DEffect(
            .degrees(isVisible ? 0 : 45),
            axis: (x: 0, y: 1, z: 0),
            anchor: .leading
        )
    }
}

struct PhysicalActivityCard: View {
    @Binding var isActive: Bool
    let delay: Double
    let isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "figure.walk")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(Color.green))
                    .scaleEffect(isVisible ? 1 : 0)
                    .animation(.spring().delay(delay), value: isVisible)
                
                Text("4. Physical Activity")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.white)
                    .offset(x: isVisible ? 0 : 50)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.spring().delay(delay + 0.1), value: isVisible)
            }
            
            Text("Did you engage in at least 30 minutes of moderate physical activity today?")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .offset(y: isVisible ? 0 : 20)
                .opacity(isVisible ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(delay + 0.2), value: isVisible)
            
            // Fixed Toggle Layout
            HStack {
                Spacer() // Push the toggle to the right
                ToggleContainer(isActive: $isActive)
                    .scaleEffect(isVisible ? 1 : 0.5)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.spring().delay(delay + 0.3), value: isVisible)
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensure the card takes full width
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 5, y: 5)
        )
        .offset(x: isVisible ? 0 : -UIScreen.main.bounds.width)
        .rotation3DEffect(
            .degrees(isVisible ? 0 : 45),
            axis: (x: 0, y: 1, z: 0),
            anchor: .leading
        )
    }
}

struct ToggleContainer: View {
    @Binding var isActive: Bool
    
    var body: some View {
        HStack {
            Text("No")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Toggle("", isOn: $isActive)
                .toggleStyle(SwitchToggleStyle(tint: .green))
                .labelsHidden()
                .fixedSize()  // Prevent toggle from expanding
            
            Text("Yes")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.2))
        )
    }
}
