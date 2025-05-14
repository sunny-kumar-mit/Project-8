import SwiftUI

struct ScoreView: View {
    var sleepHours: Double
    var stressLevel: Double
    var moodRating: Double
    var physicalActivity: Bool
    @State private var progress: CGFloat = 0.0
    @State private var animateParticles = false
    @State private var showRecommendations = false
    @State private var glow = false
    
    // Score calculations
    private var totalScore: Int {
        let sleepScore = Int((sleepHours / 7) * 25)
        let stressScore = Int(((10 - stressLevel) / 9) * 25)
        let moodScore = Int((moodRating / 10) * 25)
        let activityScore = physicalActivity ? 25 : 0
        return min(sleepScore + stressScore + moodScore + activityScore, 100)
    }
    
    private var scoreColor: Color {
        switch totalScore {
        case 80...100: return .green
        case 60..<80: return .orange
        default: return .red
        }
    }
    
    private var scoreTitle: String {
        switch totalScore {
        case 80...100: return "🌟 Thriving!"
        case 60..<80: return "💪 Good Job!"
        default: return "🚀 Let's Improve!"
        }
    }
    
    var body: some View {
        ZStack {
            // Animated background
            AngularGradient(gradient: Gradient(colors: [.purple, .blue, .pink, .purple]), 
                            center: .center)
            .hueRotation(.degrees(glow ? 45 : 0))
            .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: glow)
            .edgesIgnoringSafeArea(.all)
            .blur(radius: 50)
            
            // Floating particles
            ForEach(0..<30) { _ in
                Circle()
                    .frame(width: CGFloat.random(in: 2...6), height: CGFloat.random(in: 2...6))
                    .foregroundColor([.white, .yellow, .green].randomElement()!)
                    .opacity(0.4)
                    .offset(x: CGFloat.random(in: -200...200), 
                            y: animateParticles ? CGFloat.random(in: -200...200) : CGFloat.random(in: -200...200))
                    .animation(Animation.easeInOut(duration: Double.random(in: 3...6)).repeatForever(), value: animateParticles)
            }
            
            VStack(spacing: 30) {
                // Score Ring
                ZStack {
                    Circle()
                        .stroke(lineWidth: 20)
                        .opacity(0.3)
                        .foregroundColor(scoreColor)
                    
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .fill(scoreColor)
                        .rotationEffect(.degrees(-90))
                        .shadow(color: scoreColor.opacity(0.5), radius: 15)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                    
                    VStack {
                        Text("\(totalScore)")
                            .font(.system(size: 60, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .scaleEffect(glow ? 1.1 : 1)
                            .animation(.easeInOut(duration: 1).repeatForever(), value: glow)
                        
                        Text(scoreTitle)
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .frame(width: 220, height: 220)
                .padding(.top, 40)
                
                // Recommendations
                ScrollView {
                    VStack(spacing: 20) {
                        RecommendationCard(icon: "bed.double.fill", 
                                           color: .blue,
                                           text: sleepRecommendation)
                        
                        RecommendationCard(icon: "brain.head.profile", 
                                           color: .purple,
                                           text: stressRecommendation)
                        
                        RecommendationCard(icon: "face.smiling", 
                                           color: .orange,
                                           text: moodRecommendation)
                        
                        RecommendationCard(icon: "figure.walk", 
                                           color: .green,
                                           text: activityRecommendation)
                    }
                    .padding()
                    .opacity(showRecommendations ? 1 : 0)
                    .offset(y: showRecommendations ? 0 : 50)
                    .animation(.spring().delay(0.5), value: showRecommendations)
                }
            }
        }
        .onAppear {
            withAnimation {
                progress = CGFloat(totalScore) / 100
                glow = true
                animateParticles = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showRecommendations = true
                }
            }
        }
    }
    
    // Recommendation Content
    private var sleepRecommendation: String {
        sleepHours >= 7 ? 
        "Great sleep habits! Keep it up!" :
        "Aim for 7+ hours of quality sleep"
    }
    
    private var stressRecommendation: String {
        stressLevel <= 5 ?
        "Good stress management!" :
        "Try meditation or short breaks"
    }
    
    private var moodRecommendation: String {
        moodRating >= 7 ?
        "Excellent mood levels!" :
        "Try mood-boosting activities"
    }
    
    private var activityRecommendation: String {
        physicalActivity ?
        "Great job staying active!" :
        "Add 30 mins of daily activity"
    }
}

struct RecommendationCard: View {
    let icon: String
    let color: Color
    let text: String
    @State private var animate = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .clipShape(Circle())
                .scaleEffect(animate ? 1 : 0)
                .animation(.spring().delay(0.2), value: animate)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.leading, 10)
                .opacity(animate ? 1 : 0)
                .offset(x: animate ? 0 : 20)
                .animation(.easeOut.delay(0.3), value: animate)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        )
        .onAppear { animate = true }
    }
}
