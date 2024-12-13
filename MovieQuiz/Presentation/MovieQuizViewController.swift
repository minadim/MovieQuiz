import UIKit

final class MovieQuizViewController: UIViewController,  QuestionFactoryDelegate {
    
    // подключить элементы интерфейса к коду
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    private let statisticService: StatisticServiceProtocol = StatisticService()
    private let resultAlertPresenter = ResultAlertPresenter() // Создание экземпляра
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Отложенная инициализация фабрики
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        
        // Настройка начальных свойств рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        
        // сохранения текущей даты
        UserDefaults.standard.set(Date(), forKey: "bestGame.date")
        
        
        questionFactory.requestNextQuestion()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(isYes: true)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(isYes: false)
        
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol!
    private var currentQuestion: QuizQuestion?
    
    private var totalAccuracy: Double {
        guard statisticService.gamesCount > 0 else { return 0 }
        return Double(correctAnswers) / Double(statisticService.gamesCount) * 100
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
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
    
    private func showFirstQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    private func handleAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        changeButtonState(isEnabled: false)
        let isCorrect = (isYes == currentQuestion.correctAnswer)
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.hideBorder()
            self.showNextQuestionOrResults()
            self.changeButtonState(isEnabled: true)
        }
    }
    private func hideBorder() {
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showResults()
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
            
        }
    }
    
    private func showResults() {
        statisticService.store(correct: correctAnswers, total: questionsAmount)

        // Создание и настройка DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy" // Устанавливаем нужный формат даты
        let formattedDate = dateFormatter.string(from: Date()) // Форматируем текущую дату

        // Создание ViewModel с отформатированной датой
        let resultViewModel = QuizResultsViewModel(
            title: "Результаты",
            text: "Вы правильно ответили на \(correctAnswers) из \(questionsAmount) вопросов!\n" +
                  "Количество завершённых игр: \(statisticService.gamesCount)\n" +
                  "Лучший результат: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total)\n" +
                  "Средняя точность: \(totalAccuracy)%\n" +
                  "Дата: \(formattedDate)",
            buttonText: "Сыграть ещё раз",
            date: Date()
        )

        // Отображение результата через алерт
        resultAlertPresenter.showResultAlert(
            title: resultViewModel.title,
            message: resultViewModel.text,
            buttonText: resultViewModel.buttonText,
            on: self
        ) { [weak self] in
            self?.resetQuiz()
        }
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak self] _ in
            self?.resetQuiz()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func resetQuiz() {
            currentQuestionIndex = 0
            correctAnswers = 0
            hideBorder()
        showFirstQuestion()
        }
    
    private func changeButtonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(viewModel)
            
        }
    }
}
