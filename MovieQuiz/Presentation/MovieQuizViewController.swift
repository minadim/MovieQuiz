import UIKit

final class MovieQuizViewController: UIViewController {
    
    // подключить элементы интерфейса к коду
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка начальных свойств рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.white.cgColor
        
    }
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(isYes: true)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(isYes: false)
        
    }
    
    // Моковый список вопросов для приложения структура
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
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    
    // приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let image = UIImage(named: model.image) ?? UIImage()
        let questionText = model.text
        let questionNumber = "\(currentQuestionIndex + 1) / \(questions.count)"
        
        return QuizStepViewModel(
            image: image,
            question: questionText,
            questionNumber: questionNumber
        )
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    
    private func show(_ step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    // Метод для показа первого вопроса при загрузке
    private func showFirstQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: currentQuestion)
        show(viewModel)
    }
    // Обработка ответа пользователя
    private func handleAnswer(isYes: Bool) {
    let isCorrect = (isYes == questions[currentQuestionIndex].correctAnswer)
       
        
        showAnswerResult(isCorrect: isCorrect)
    }
    // Приватный метод, который меняет цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
                correctAnswers += 1 // Увеличить счётчик правильных ответов
            }
        // Настройка рамки в зависимости от правильности ответа
               imageView.layer.masksToBounds = true
               imageView.layer.borderWidth = 8
imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            
        }
    }
    // приватный метод, который содержит логику перехода в один из сценариев

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 { // 1
            showResults()
        } else { // 2
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(_: viewModel)
        }
    }
        private func showResults() {
            let resultViewModel = QuizResultsViewModel(
                        title: "Результаты",
                        text: "Вы правильно ответили на \(correctAnswers) из \(questions.count) вопросов!",
                        buttonText: "Сыграть ещё раз"
                    )
                    show(quiz: resultViewModel)
                }
                
                // приватный метод для показа результатов раунда квиза
                // принимает вью модель QuizResultsViewModel и ничего не возвращает
                private func show(quiz result: QuizResultsViewModel) {
                    let alert = UIAlertController(
                        title: result.title,
                        message: result.text,
                        preferredStyle: .alert
                    )
            
let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
                // Сбрасываем игру и показываем первый вопрос
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
                self.show(viewModel)
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Структуры для хранения данных
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
