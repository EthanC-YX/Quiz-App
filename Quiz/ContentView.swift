import SwiftUI
import AVFoundation

struct Question {
    let question: String
    let option1: String
    let option2: String
    let option3: String
    let option4: String
    let correctOption: String
}

class QuizViewModel: ObservableObject {
    let quiz: [Question] = [
        Question(question: "Which keyword is used to define a constant in Swift?", option1: "constant", option2: "var", option3: "let", option4: "const", correctOption: "let"),
        Question(question: "What is the shorthand notation for incrementing a variable in Swift?", option1: "increment(variable)", option2: "variable = variable + 1", option3: "variable += 1", option4: "variable++", correctOption: "variable += 1"),
        Question(question: "Which type of loop is used to iterate over a sequence of items in Swift?", option1: "if statement", option2: "while loop", option3: "repeat-while loop", option4: "for-in loop", correctOption: "for-in loop"),
        Question(question: "What is the purpose of the 'guard' statement in Swift?", option1: "To check for equality between two values", option2: "To define a new scope for variables and constants", option3: "To handle errors and exceptions", option4: "To exit early from a function or method if a condition is not met", correctOption: "To exit early from a function or method if a condition is not met"),
        Question(question: "What is Swift?", option1: "A superhero", option2: "A type of bird", option3: "A popular music genre", option4: "A programming language developed by Apple", correctOption: "A programming language developed by Apple"),
        Question(question: "What is Taylor Swift's full name?", option1: "Taylor Nicole Swift", option2: "Taylor Marie Swift", option3: "Taylor Elizabeth Swift", option4: "Taylor Alison Swift", correctOption: "Taylor Alison Swift"),
        Question(question: "What is the title of Taylor Swift's debut album?", option1: "1989", option2: "Fearless", option3: "Speak Now", option4: "Taylor Swift", correctOption: "Taylor Swift"),
        Question(question: "Which Taylor Swift song starts with the lyrics 'We were both young when I first saw you'?", option1: "Shake It Off", option2: "You Belong with Me", option3: "Blank Space", option4: "Love Story", correctOption: "Love Story"),
        Question(question: "In which year did Taylor Swift win her first Grammy Award?", option1: "2016", option2: "2012", option3: "2010", option4: "2009", correctOption: "2010"),
        Question(question: "What is Taylor Swift's best-selling album to date?", option1: "Speak Now", option2: "Red", option3: "Fearless", option4: "1989", correctOption: "1989")
    ]
    
    
    
    @Published var index = 0
    @Published var count = 0
    @Published var showSheet = false
    @Published var showSummary = false
    @Published var isCorrectAnswer = false
    @Published var timeRemaining = 30
    @Published var timer: Timer?
    
    var audioPlayer: AVAudioPlayer?
    
    func checkAnswer(isCorrect: Bool) {
        isCorrectAnswer = isCorrect
        if isCorrectAnswer {
            count += 1
        }
        
        stopTimer()
        index += 1
        
        if index == quiz.count {
            showSummary = true
            stopBackgroundMusic()
        } else {
            showSheet = true
        }
        
        startTimer() // Reset the timer to 10
    }
    
    func restart() {
        index = 0
        count = 0
        showSummary = false
        stopBackgroundMusic()
    }
    
    func playBackgroundMusic() {
        guard let audioURL = Bundle.main.url(forResource: "kahoot_lobby_music_80s_edition", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.numberOfLoops = -1 // Infinite loop
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func startTimer() {
        timeRemaining = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stopTimer()
                self.checkAnswer(isCorrect: false)
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView: View {
    @StateObject private var viewModel = QuizViewModel()
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    if !viewModel.showSummary {
                        Text("\(viewModel.timeRemaining)")
                            .foregroundColor(.black)
                            .font(.system(size: 40, weight: .bold))
                            .frame(width: 100, height: 100)
                            .background(Color.white)
                            .clipShape(Circle())
                            .padding(.top, 20)
                    }
                }
                .frame(maxWidth: .infinity)
                
                if !viewModel.showSummary {
                    Text(viewModel.quiz[viewModel.index].question)
                        .padding()
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .bold()
                    
                    VStack {
                        Button(action: {
                            viewModel.checkAnswer(isCorrect: viewModel.quiz[viewModel.index].option1 == viewModel.quiz[viewModel.index].correctOption)
                        }) {
                            HStack {
                                Image(systemName: "square.fill")
                                Text(viewModel.quiz[viewModel.index].option1)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black)
                            )
                        }
                        
                        Button(action: {
                            viewModel.checkAnswer(isCorrect: viewModel.quiz[viewModel.index].option2 == viewModel.quiz[viewModel.index].correctOption)
                        }) {
                            HStack {
                                Image(systemName: "square.fill")
                                Text(viewModel.quiz[viewModel.index].option2)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black)
                            )
                        }
                        
                        Button(action: {
                            viewModel.checkAnswer(isCorrect: viewModel.quiz[viewModel.index].option3 == viewModel.quiz[viewModel.index].correctOption)
                        }) {
                            HStack {
                                Image(systemName: "diamond.fill")
                                Text(viewModel.quiz[viewModel.index].option3)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black)
                            )
                        }
                        
                        Button(action: {
                            viewModel.checkAnswer(isCorrect: viewModel.quiz[viewModel.index].option4 == viewModel.quiz[viewModel.index].correctOption)
                        }) {
                            HStack {
                                Image(systemName: "circle.fill")
                                Text(viewModel.quiz[viewModel.index].option4)
                                    .fontWeight(.semibold)
                                    .font(.title2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black)
                            )
                        }
                    }
                    .padding(.top, 30)
                } else {
                    SummaryView(score: viewModel.count, totalQuestions: viewModel.quiz.count, restartQuiz: viewModel.restart)
                }
                
                Spacer()
                
                if !viewModel.showSummary {
                    HStack {
                        Text("Kahoot Lobby Music 80s Edition")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .bold()
                        
                        Button(action: {
                            isPlaying.toggle()
                            if isPlaying {
                                viewModel.playBackgroundMusic()
                            } else {
                                viewModel.stopBackgroundMusic()
                            }
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            viewModel.playBackgroundMusic()
            viewModel.startTimer()
        }
        .sheet(isPresented: $viewModel.showSheet) {
            AnswerView(isCorrectAnswer: $viewModel.isCorrectAnswer)
                .presentationDetents([.medium])
                .onDisappear {
                    if viewModel.showSummary {
                        viewModel.restart()
                    }
                }
        }
    }
}

struct SummaryView: View {
    let score: Int
    let totalQuestions: Int
    let restartQuiz: () -> Void
    
    var scoreMessage: String {
        switch score {
        case ..<3:
            return "WOW U SUCK"
        case 4...6:
            return "eh decent score ig"
        case 7...10:
            return "U ROCK 🤩"
        default:
            return ""
        }
    }
    
    var body: some View {
        VStack {
            Text("Quiz Summary")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            DoughnutChartView(score: score, totalQuestions: totalQuestions)
                .frame(width: 200, height: 200)
                .padding()
            
            Spacer()
            
            Text("Score: \(score) / \(totalQuestions)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
            
            Text(scoreMessage) // Display score message
                .font(.title2)
                .bold()
                .padding()
                .foregroundColor(.white)
                .cornerRadius(10)
            
            Button(action: {
                restartQuiz()
            }) {
                Text("Restart")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black)
                    )
            }
        }
    }
}

struct DoughnutChartView: View {
    let score: Int
    let totalQuestions: Int
    
    var body: some View {
        let percentage = Double(score) / Double(totalQuestions)
        let angle = 360.0 * percentage
        
        return ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0, to: CGFloat(angle) / 360.0)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(-90))
            
            Text("\(score) / \(totalQuestions)")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.title)
        }
    }
}

struct AnswerView: View {
    @Binding var isCorrectAnswer: Bool
    
    var body: some View {
        VStack {
            if isCorrectAnswer {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.green)
                    .padding()
                
                Text("Correct!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            } else {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(.red)
                    .padding()
                
                Text("Wrong!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
