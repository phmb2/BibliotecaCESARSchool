//
//  Book.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 26/03/21.
//

import Foundation

struct Book: Codable, Equatable {
    var title: String
    var isbn: String?
    var pageCount: Int
    var thumbnailUrl: URL?
    var shortDescription: String?
    var longDescription: String?
    var authors: [String]
    var categories: [String]
    var publishedDate: Date?
    var quantity: Int
}

struct Section {
    let category: String
    let books: [Book]
}
