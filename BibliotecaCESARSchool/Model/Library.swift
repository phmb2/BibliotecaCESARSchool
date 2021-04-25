//
//  Library.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 26/03/21.
//

import Foundation

class Library {
    static var shared = Library()
    private init() {}

    var books: [Book] = {
        let contents = try! Data(contentsOf: Bundle.main.url(forResource: "books", withExtension: "json")!)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let booksList = try! decoder.decode([Book].self, from: contents)
        return booksList
    }()
}
