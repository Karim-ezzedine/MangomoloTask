//
//  HomeViewModel.swift
//  MangomoloTask
//
//  Created by Karim Ezzedine on 10/02/2024.
//

import Foundation
import Combine

class HomeViewModel {
    
    //MARK: - Published Properties
    
    @Published var verticalMoviesData: Movies = []
    @Published var horizontalMoviesData: Movies = []
}

//MARK: - Methods

extension HomeViewModel {
    func getMoviesaData() {
        self.verticalMoviesData = MoviesDummyData.verticalMovies()
        self.horizontalMoviesData = MoviesDummyData.horizontalMovies()
    }
}
