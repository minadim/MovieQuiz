import UIKit

final class MovieQuizViewController: UIViewController,  QuestionFactoryDelegate {
    
    // подключить элементы интерфейса к коду
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
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
        
    
        questionFactory.requestNextQuestion() // изменение
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        handleAnswer(isYes: true)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        handleAnswer(isYes: false)
        
    }
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol!
    private var currentQuestion: QuizQuestion?
    
    
    
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
        questionFactory?.requestNextQuestion() // Запрос нового вопроса без использования if let

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
            questionFactory.requestNextQuestion() // Исправлено

            }
        }
    
    private func showResults() {
        let resultViewModel = QuizResultsViewModel(
            title: "Результаты",
            text: "Вы правильно ответили на \(correctAnswers) из \(questionsAmount) вопросов!",
            buttonText: "Сыграть ещё раз"
        )
        show(quiz: resultViewModel)
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.hideBorder()
            
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    private func changeButtonState(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
        
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
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
