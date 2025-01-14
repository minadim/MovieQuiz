//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Nadin on 05.01.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    func testYesButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    func testNoButton() {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        let indexLabel = app.staticTexts["Index"]
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    func testGameRoundCompletion() {
        for _ in 1...10 {
            app.buttons["Нет"].tap()
            sleep(1)
        }
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists, "Алерт не появился после завершения раунда")
        XCTAssertEqual(alert.label, "Этот раунд окончен!", "Неверный заголовок алерта")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз", "Неверный текст кнопки на алерте")
    }
    func testAlertDismissalAndGameReset() {
        for _ in 1...10 {
            app.buttons["Нет"].tap()
            sleep(3)
        }
        let alert = app.alerts["Game results"]
        XCTAssertTrue(alert.exists, "Алерт не появился после завершения раунда")
        alert.buttons.firstMatch.tap()
        sleep(3)
        XCTAssertFalse(alert.exists, "Алерт не закрылся")
        XCTAssertEqual(app.staticTexts["Index"].label, "1/10", "Состояние игры не сбросилось после закрытия алерта")
    }
}

