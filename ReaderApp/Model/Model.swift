
//  Model.swift
//  ReaderApp
//  Created by swaim yadav on 26/07/25.

import Foundation

// MARK: - Welcome
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?
    let content: String?
    var isbookmarked : Bool?
    
}


// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
