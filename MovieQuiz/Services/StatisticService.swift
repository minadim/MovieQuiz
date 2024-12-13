//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Nadin on 11.12.2024.
//

import UIKit

// Реализация протокола StatisticServiceProtocol
final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
            case gamesCount
            case bestGame_correct
            case bestGame_total
            case bestGame_date
            case totalAccuracy
        }

        var gamesCount: Int {
            get {
                return storage.integer(forKey: Keys.gamesCount.rawValue)
            }
            set {
                storage.set(newValue, forKey: Keys.gamesCount.rawValue)
            }
        }
        
    var bestGame: GameResult {
            get {
                let correct = storage.integer(forKey: Keys.bestGame_correct.rawValue)
                let total = storage.integer(forKey: Keys.bestGame_total.rawValue)
                let date = storage.object(forKey: Keys.bestGame_date.rawValue) as? Date ?? Date()
                return GameResult(correct: correct, total: total, date: date)
            }
            set {
                storage.set(newValue.correct, forKey: Keys.bestGame_correct.rawValue)
                storage.set(newValue.total, forKey: Keys.bestGame_total.rawValue)
                storage.set(newValue.date, forKey: Keys.bestGame_date.rawValue)
            }
        }
        
        var totalAccuracy: Double {
            get { return storage.double(forKey: Keys.totalAccuracy.rawValue) }
            set { storage.set(newValue, forKey: Keys.totalAccuracy.rawValue) }
        }
        
        // Метод для сохранения текущего результата игры
        func store(correct count: Int, total amount: Int) {
            gamesCount += 1
            
            let currentGame = GameResult(correct: count, total: amount, date: Date())
            
            // Проверяем, является ли текущий результат лучшим по сравнению с сохранённым
            if currentGame.isBetterThan(bestGame) {
                bestGame = currentGame
            }
            
            // Рассчитываем и обновляем общую точность
            let currentAccuracy = Double(count) / Double(amount)
            let totalAccu = (totalAccuracy * Double(gamesCount - 1) + currentAccuracy) / Double(gamesCount)
            totalAccuracy = totalAccu * 100
            
            // Формирование сообщения для алерта
            let message = """
            Количество сыгранных игр: \(gamesCount)
            Лучшая игра:
            Правильных ответов: \(bestGame.correct) из \(bestGame.total)
            Точность: \(String(format: "%.2f", totalAccuracy))%
            """
            
            showMessageAlert(message)
        }
        
        // Метод для отображения сообщения в алерте
        private func showMessageAlert(_ message: String) {
            let alert = UIAlertController(title: "Результаты игры", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ок", style: .default)
            alert.addAction(action)
            // Present the alert (assuming this is within a view controller)
            // viewController.present(alert, animated: true, completion: nil)
        }
    }