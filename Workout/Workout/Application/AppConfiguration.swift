//
//  AppConfiguration.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

final class AppConfiguration {

    static private(set) var main = AppConfiguration()

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
