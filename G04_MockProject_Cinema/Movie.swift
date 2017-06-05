//
//  Movie.swift
//  G04_MockProject_Cinema
//
//  Created by THANH on 6/5/17.
//  Copyright © 2017 HCMUTE. All rights reserved.
//

import Foundation

class Movie {
    var filmInfo: MovieInfo
    //var showTime: ShowTime
    
    init(filmInfo: FilmInfo, showTime: ShowTime) {
        self.filmInfo = filmInfo
        self.showTime = showTime
    }
}
