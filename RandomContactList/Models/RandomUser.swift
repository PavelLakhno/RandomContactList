//
//  RandomUser.swift
//  RandomContactList
//
//  Created by Pavel Lakhno on 25.01.2023.
//

import Foundation

// MARK: - Results
struct Users: Decodable {
    let results: [User]
}

// MARK: - Result
struct User: Decodable {
    let gender: String?
    let name: Name?
    let location: Location?
    let email: String?
    let dob: Dob?
    let phone: String?
    let picture: Picture?
}

// MARK: - Dob
struct Dob: Decodable {
    let date: String?
    let age: Int?
}

// MARK: - Location
struct Location: Decodable {
    let street: Street?
    let city, state, country: String?

    init(street: Street, city: String, state: String, country: String) {
        self.street = street
        self.city = city
        self.country = country
        self.state = state
    }
}

// MARK: - Street
struct Street: Decodable {
    let number: Int?
    let name: String?

    init(number: Int, name: String) {
        self.number = number
        self.name = name
    }
}


// MARK: - Name
struct Name: Decodable {
    var first, last: String?

    init(first: String, last: String) {
        self.first = first
        self.last = last
    }
}

// MARK: - Picture
struct Picture: Decodable {
    let large, thumbnail: String?

    init(large: String, thumbnail: String) {
        self.large = large
        self.thumbnail = thumbnail
    }
}

// MARK: - Constants
enum URLConstants: String {
    case randomUserAPI = "https://randomuser.me/api"
    case randomUsersAPI = "https://randomuser.me/api/?results=15"
}

enum Segues: String {
    case showContact = "ShowContact"
}
