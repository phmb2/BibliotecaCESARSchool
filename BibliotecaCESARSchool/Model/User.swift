//
//  User.swift
//  BibliotecaCESARSchool
//
//  Created by Pedro Barbosa on 11/04/21.
//

import Foundation

struct Order: Equatable {
    var book: Book
    var loanDate: Date
}

class User {
    static var shared = User()
    private init() {}

    var orders: [Order] = []
}
