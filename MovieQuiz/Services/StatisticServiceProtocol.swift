//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Nadin on 11.12.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
