//
//  Exercise.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

// swiftlint:disable identifier_name
// MARK: - Exercises
struct Exercises: Codable {
    let count: Int
    let next: String
    let results: [Exercise]
}

// MARK: - Exercise
struct Exercise: Codable {
    let exerciseId: Int
    let name, uuid: String
    let resultDescription, creationDate: String
    let images: [Image]
    let variations: [Int]
    let category: Category
    let muscles: [Muscle]

    enum CodingKeys: String, CodingKey {
        case exerciseId = "id"
        case name, uuid
        case resultDescription = "description"
        case creationDate = "creation_date"
        case images, variations
        case category, muscles
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
}

// MARK: - Muscle
struct Muscle: Codable {
    let id: Int
    let name: String
    let isFront: Bool
    let nameEn, imageURLMain, imageURLSecondary: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case isFront = "is_front"
        case nameEn = "name_en"
        case imageURLMain = "image_url_main"
        case imageURLSecondary = "image_url_secondary"
    }
}

// MARK: - Image
struct Image: Codable {
    let exerciseId: Int
    let uuid: String
    let exerciseBase: Int
    let image: URL
    let isMain: Bool
    let status, style: String

    enum CodingKeys: String, CodingKey {
        case exerciseId = "id"
        case uuid
        case exerciseBase = "exercise_base"
        case image
        case isMain = "is_main"
        case status, style
    }
}
