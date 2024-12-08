//
//   QuestionFactoryDelegate .swift
//  MovieQuiz
//
//  Created by Nadin on 05.12.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
