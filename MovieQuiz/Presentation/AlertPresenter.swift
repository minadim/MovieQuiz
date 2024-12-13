//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Nadin on 09.12.2024.
//

import Foundation

import UIKit

class AlertPresenter {
    // Свойство для хранения экземпляра модели
    private let alertModel: AlertModel
    private weak var viewController: UIViewController?

    // Инициализатор для инициализации модели и контроллера
    init(alertModel: AlertModel, viewController: UIViewController) {
        self.alertModel = alertModel
        self.viewController = viewController
    }

    // Метод для показа алерта
    func showAlert() {
        // Создаем UIAlertController с данными из модели
        let alertController = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )

        // Добавляем кнопку и ее действие
        alertController.addAction(UIAlertAction(title: alertModel.buttonTitle, style: .default) { _ in
            self.alertModel.completion()
        })

        // Показываем алерт на контроллере
        viewController?.present(alertController, animated: true, completion: nil)
    }
}
