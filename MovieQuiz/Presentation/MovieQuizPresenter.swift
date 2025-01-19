
import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func changeButtonState(isEnabled: Bool)
    func hideBorder()
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestionIndex = 0
    private(set) var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol!
    private let statisticService: StatisticServiceProtocol
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        self.statisticService = StatisticService()
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        viewController.showLoadingIndicator()
        viewController.changeButtonState(isEnabled: false)
        questionFactory.loadData()
    }
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        let isCorrect = isYes == currentQuestion.correctAnswer
        proceedWithAnswer(isCorrect: isCorrect)
    }
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect { correctAnswers += 1 }
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        viewController?.showLoadingIndicator()
        viewController?.changeButtonState(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            let message = showResults()
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: message,
                buttonText: "Сыграть ещё раз",
                date: Date()
            )
            viewController?.hideLoadingIndicator()
            viewController?.show(quiz: resultViewModel)
        } else {
            switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.hideBorder()
            self?.viewController?.changeButtonState(isEnabled: true)
            self?.viewController?.show(quiz: viewModel)
        }
    }
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            imageData: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        viewController?.showLoadingIndicator()
        viewController?.changeButtonState(isEnabled: false)
        questionFactory.requestNextQuestion()
    }
    func showResults() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestGame = statisticService.bestGame
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let formattedDate = dateFormatter.string(from: bestGame.date)
        let averageAccuracy = Double(correctAnswers) / Double(questionsAmount) * 100
        
        return """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных квизов: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))
        Средняя точность: \(String(format: "%.2f", averageAccuracy))%
        """
    }
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
