//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Nadin on 09.12.2024.
//


import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonTitle: String
    var completion: () -> Void
}
