//
//   QuestionFactoryDelegate .swift
//  MovieQuiz
//
//  Created by Nadin on 05.12.2024.
//


import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
