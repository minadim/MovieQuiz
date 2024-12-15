//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by Nadin on 13.12.2024.
//

import UIKit

final class ResultAlertPresenter {
    
    func showResultAlert(
        title: String,
        message: String,
        buttonText: String,
        on viewController: UIViewController,
        completion: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonText, style: .default) { _ in
            completion()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
}
