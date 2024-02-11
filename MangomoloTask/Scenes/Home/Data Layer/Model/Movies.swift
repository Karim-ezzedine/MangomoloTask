//
//  Movie.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 09/02/2024.
//

import UIKit
import Combine

typealias Movies = [Movie]

class Movie {
    var movieImageUrl: String?
    var imaAdsTag: String?
    var hlsMediaUrl: String?
    
    var movieImage: UIImage?
    
    init(movieImageUrl: String? = nil,
         imaAdsTag: String? = nil,
         hlsMediaUrl: String? = nil) {
        self.movieImageUrl = movieImageUrl
        self.imaAdsTag = imaAdsTag
        self.hlsMediaUrl = hlsMediaUrl
    }
    
    func loadImage() -> AnyPublisher<UIImage?, Never> {
        if let imageURL = URL(string: movieImageUrl ?? "") {
            return URLSession.shared.dataTaskPublisher(for: imageURL)
                .map { data, _ in UIImage(data: data) }
                .replaceError(with: nil)
                .eraseToAnyPublisher()
        }
        else {
            return Just(nil).eraseToAnyPublisher()
        }
    }
}
