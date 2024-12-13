//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Nadin on 09.12.2024.
//

import Foundation

struct AlertModel {
    var title: String          // Заголовок алерта
    var message: String        // Сообщение в алерте
    var buttonTitle: String    // Текст кнопки
    var completion: () -> Void // Замыкание для действия по кнопке алерта
}
