//
//  Parsable.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

protocol Parsable {
    associatedtype Object: Codable
    func parse(data: Data) -> Object?
}
