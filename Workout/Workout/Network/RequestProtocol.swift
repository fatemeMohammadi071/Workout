//
//  RequestProtocol.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation
import Alamofire

protocol RequestProtocol {
    var baseURL: String {get}
    var relativePath: String {get}
    var method: HTTPMethod {get}
    var headers: [String: String]? {get}
    var parameters: [String: Any]? {get}
    var interceptor: RequestInterceptor? {get}
}

extension RequestProtocol {
    var baseURL: String {
        return AppConfiguration.main.apiBaseURL
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    var parameters: [String: Any]? {
        return [:]
    }
    var interceptor: RequestInterceptor? {
        return nil
    }
    var method: HTTPMethod {
        return .get
    }
}
