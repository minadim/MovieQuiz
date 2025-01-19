// QuestionFactory.swift
// MovieQuiz
//
// Created by Nadin on 26.12.2024.


import UIKit

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
                    DispatchQueue.main.async { [weak self] in
                        guard self != nil else { return }
                        let alert = UIAlertController(title: "Ошибка",
                                                      message: "Не удалось загрузить изображение постера фильма.",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                    }
                    return
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard self != nil else { return }
                    let alert = UIAlertController(title: "Ошибка",
                                                  message: "URL изображения фильма недействителен.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                }
                return
            }
            let rating = Float(movie.imDbRating) ?? 0
            let randomThreshold = Float.random(in: 1...10)
            let isGreaterThan = rating > randomThreshold
            let comparisonText = isGreaterThan ? "больше" : "меньше"
            let text = "Рейтинг этого фильма \(comparisonText) чем \(String(format: "%.1f", randomThreshold))?"
            let correctAnswer = isGreaterThan
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
