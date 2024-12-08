//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Nadin on 05.12.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
}
