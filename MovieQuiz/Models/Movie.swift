//
//  Movie.swift
//  MovieQuiz
//
//  Created by Nadin on 29.12.2024.
//

import Foundation

struct Movie: Decodable {
    let id: String
    let rank: String
    let title: String
    let fullTitle: String
    let year: String
    let image: String
    let imDbRating: String
    let imDbRatingCount: String
}
