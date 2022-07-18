//
//  ExercisesEndPoint.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

enum ExercisesEndPoint {
    case getExercises
}

extension ExercisesEndPoint: RequestProtocol {

    public var relativePath: String {
        switch self {
        case .getExercises:
            return "exerciseinfo/"
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
