import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    func presentAlert(alert: UIAlertController) {
    }
    func didFailToLoadImage(with error: Error) {
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let statisticService: StatisticServiceProtocol = StatisticService()
    private let resultAlertPresenter = ResultAlertPresenter()
    private var questionFactory: QuestionFactoryProtocol!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDependencies()
        showLoadingIndicator()
        questionFactory.loadData()
    }
    private func setupUI() {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        activityIndicator.hidesWhenStopped = true
    }
    private func setupDependencies() {
        let moviesLoader = MoviesLoader()
        let questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: self)
        self.questionFactory = questionFactory
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(isYes: true)
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(isYes: false)
    }
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(viewModel)
            self?.hideLoadingIndicator()
        }
    }
    private func handleAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        DispatchQueue.main.async { [weak self] in
            self?.changeButtonState(isEnabled: false)
        }
        let isCorrect = (isYes == currentQuestion.correctAnswer)
        showAnswerResult(isCorrect: isCorrect)
    }
    private func showAnswerResult(isCorrect: Bool) {
        if !Thread.isMainThread {
        }
        if isCorrect { correctAnswers += 1 }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.hideBorder()
                self.showNextQuestionOrResults()
                self.changeButtonState(isEnabled: true)
            }
        }
    }
    private func showNextQuestionOrResults() {
        showLoadingIndicator()
        if currentQuestionIndex == questionsAmount - 1 {
            showResults()
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    private func showResults() {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let averageAccuracy = statisticService.averageAccuracy
        let bestGame = statisticService.bestGame
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        let formattedDate = dateFormatter.string(from: bestGame.date)
        let resultViewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(bestGame.correct)/\(bestGame.total) (\(formattedDate))
                Средняя точность: \(String(format: "%.2f", averageAccuracy))%
                """,
            buttonText: "Сыграть ещё раз",
            date: Date()
        )
        resultAlertPresenter.showResultAlert(
            title: resultViewModel.title,
            message: resultViewModel.text,
            buttonText: resultViewModel.buttonText,
            on: self
        ) { [weak self] in
            self?.resetQuiz()
        }
    }
    private func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        hideBorder()
        questionFactory.requestNextQuestion()
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(data: model.image) ?? UIImage()
        let questionText = model.text
        let questionNumber = "\(currentQuestionIndex + 1) / \(questionsAmount)"
        return QuizStepViewModel(
            image: image,
            question: questionText,
            questionNumber: questionNumber
        )
    }
    private func show(_ step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    private func hideBorder() {
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    private func changeButtonState(isEnabled: Bool) {
        if !Thread.isMainThread {
        }
        DispatchQueue.main.async { [weak self] in
            self?.yesButton.isEnabled = isEnabled
            self?.noButton.isEnabled = isEnabled
        }
    }
    // MARK: - Методы делегата QuestionFactoryDelegate
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    func didFailToLoadData(with error: Error) {
        self.hideLoadingIndicator()
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - Функция для отображения ошибки сети
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Попробовать ещё раз", style: .default) { _ in
        }
        alertController.addAction(retryAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    private func showLoadingIndicator() {
        guard Thread.isMainThread else { return }
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        guard Thread.isMainThread else { return }
        activityIndicator.stopAnimating()
    }
}

