//
//  MovieQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Nadin on 13.01.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) { }
    func show(quiz result: QuizResultsViewModel) { }
    func highlightImageBorder(isCorrectAnswer: Bool) { }
    func showLoadingIndicator() { }
    func hideLoadingIndicator() { }
    func showNetworkError(message: String) { }
    func changeButtonState(isEnabled: Bool) { }
    func hideBorder() { }
}
final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        // Given
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        // When
        let viewModel = sut.convert(model: question)
        // Then
        XCTAssertNotNil(viewModel.imageData)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
