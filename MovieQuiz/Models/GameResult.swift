//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Nadin on 11.12.2024.
//


import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    // Метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
