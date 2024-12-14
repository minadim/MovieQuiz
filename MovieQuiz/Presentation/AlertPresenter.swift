//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Nadin on 09.12.2024.
//

import UIKit

class AlertPresenter {
    private let alertModel: AlertModel
    private weak var viewController: UIViewController?
    
    init(alertModel: AlertModel, viewController: UIViewController) {
        self.alertModel = alertModel
        self.viewController = viewController
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: alertModel.buttonTitle, style: .default) { _ in
            self.alertModel.completion()
        })
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
