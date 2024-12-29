//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Nadin on 09.12.2024.
//

import UIKit

final class AlertPresenter {
    private let alertModel: AlertModel
    private weak var viewController: UIViewController?
    
    init(alertModel: AlertModel, viewController: UIViewController) {
        self.alertModel = alertModel
        self.viewController = viewController
    }
    static func showAlert(on viewController: UIViewController,
                          withModel alertModel: AlertModel,
                          completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        })
        alertController.addAction(action)
        viewController.present(alertController, animated: true, completion: nil)
    }
}


