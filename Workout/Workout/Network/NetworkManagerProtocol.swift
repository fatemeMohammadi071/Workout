//
//  NetworkManagerProtocol.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

protocol NetworkManagerProtocol {
    typealias CompletionHandler = ((Result<Data?, NetworkError>) -> Void)

    @discardableResult
    func request<RequestType: RequestProtocol>(_ request: RequestType,
                                               completion: @escaping CompletionHandler) -> Request?
    @discardableResult
    func downloadFile(downloadURL: String,
                      filePath: URL,
                      progress: @escaping ((Progress) -> Void),
                      completion: @escaping CompletionHandler) -> Request?
}
