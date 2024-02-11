//
//  MovieImagCollectionViewCell.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 10/02/2024.
//

import UIKit
import Combine

class MovieImagCollectionViewCell: UICollectionViewCell {

    //MARK: - @IBOutlet
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    //MARK: - Properties
    
    var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieImageView.backgroundColor = .customGray
        movieImageView.clipsToBounds = true
        movieImageView.layer.cornerRadius = 16
    }
    
    var movie: Movie! {
        didSet {
            if let image = movie.movieImage {
                self.movieImageView.image = image
            }
            else {
                movie.loadImage()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] image in
                        self?.movie.movieImage = image
                        self?.movieImageView.image = image
                    }
                    .store(in: &cancellables)
            }
        }
    }
}
