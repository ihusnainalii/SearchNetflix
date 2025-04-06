//
//  MovieDetailModel.swift
//  SearchFlix
//
//  Created by Husnian Ali on 18.02.2025.
//

import Foundation

struct MovieDetailModel: Decodable {
    var title: String
    var year: String
    var relased: String
    var genre: String
    var director: String
    var writer: String
    var actors: String
    var plot: String
    var language: String
    var county: String
    var award: String
    var poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case relased = "Released"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case county = "Country"
        case award = "Awards"
        case poster = "Poster"
    }
}
