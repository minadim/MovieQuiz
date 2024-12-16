import UIKit

final class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case totalCorrect
        case totalQuestions
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
    
    var totalCorrect: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrect.rawValue)
        }
    }
    
    var totalQuestions: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
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
    
    var averageAccuracy: Double {
        let totalQuestions = self.totalQuestions
        guard totalQuestions > 0 else { return 0.0 }
        return (Double(totalCorrect) / Double(totalQuestions)) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        totalCorrect += count
        totalQuestions += amount
        
        let currentGame = GameResult(correct: count, total: amount, date: Date())
        
        if currentGame.isBetterThan(bestGame) {
            bestGame = currentGame
        }
        
        let currentAccuracy = Double(count) / Double(amount)
        let totalAccu = (totalAccuracy * Double(gamesCount - 1) + currentAccuracy) / Double(gamesCount)
        totalAccuracy = totalAccu * 100
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        _ = dateFormatter.string(from: currentGame.date)
        
    }
    
}
