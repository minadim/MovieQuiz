import Foundation

struct Movie: Decodable {
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let imDbRating: String
    let imDbRatingCount: String
}

struct MostPopularMovies: Decodable {
    let items: [Movie]
}


final class QuestionFactory: QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
    
    private var movies: [Movie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    /*
     private let questions: [QuizQuestion] = [
     QuizQuestion(
     image: "The Godfather",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     
     QuizQuestion(
     image: "The Dark Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     
     QuizQuestion(
     image: "Kill Bill",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     
     QuizQuestion(
     image: "The Avengers",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     
     QuizQuestion(
     image: "Deadpool",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     
     QuizQuestion(
     image: "The Green Knight",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: true),
     
     QuizQuestion(
     image: "Old",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     
     QuizQuestion(
     image: "The Ice Age Adventures of Buck Wild",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     
     QuizQuestion(
     image: "Tesla",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false),
     
     QuizQuestion(
     image: "Vivarium",
     text: "Рейтинг этого фильма больше чем 6?",
     correctAnswer: false)
     ]
     */
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] (result: Result<MostPopularMovies, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            guard let movie = self.movies.randomElement() else { return }
            
            var imageData = Data()
            
            if let imageURL = URL(string: movie.image) {
                do {
                    imageData = try Data(contentsOf: imageURL)
                } catch {
                    print("Failed to load image from URL: \(error.localizedDescription)")
                }
            } else {
                print("Invalid URL for image: \(movie.image)")
            }
            
            let rating = Float(movie.imDbRating) ?? 0
            let randomThreshold = Float.random(in: 1...10)
            
            let text = "Рейтинг этого фильма больше, чем \(String(format: "%.1f", randomThreshold))?"
            let correctAnswer = rating > randomThreshold
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
