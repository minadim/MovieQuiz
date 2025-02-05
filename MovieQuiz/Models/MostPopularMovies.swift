//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Nadin on 26.12.2024.
//


import Foundation

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    let errorMessage: String?
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        return newURL
    }
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
        case errorMessage = "errorMessage"
    }
}
