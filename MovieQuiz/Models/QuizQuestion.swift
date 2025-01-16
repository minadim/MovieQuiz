//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Nadin on 03.12.2024.
//

import UIKit

public struct QuizQuestion {
    public let image: Data
    public let text: String
    public let correctAnswer: Bool
    
    public init(image: Data, text: String, correctAnswer: Bool) {
        self.image = image
        self.text = text
        self.correctAnswer = correctAnswer
    }
}
