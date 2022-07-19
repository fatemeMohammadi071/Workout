//
//  NetworkManager.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

extension NetworkError {
    public var isNotFoundError: Bool { return hasStatusCode(404) }

    public func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

final class NetworkManager: NetworkManagerProtocol {

    private let networkLayer: NetworkLayerProtocol

    init(networkLayer: NetworkLayerProtocol = NetworkLayer()) {
        self.networkLayer = networkLayer
    }

    @discardableResult
    func request<RequestType: RequestProtocol>(_ request: RequestType,
                                               completion: @escaping CompletionHandler) -> Request? {
        return networkLayer.request(model: request) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.resolve(error: error)))
            }
        }
    }

    // swiftlint:disable line_length
    @discardableResult
    func downloadFile(downloadURL: String,
                      filePath: URL,
                      progress: @escaping ((Progress) -> Void),
                      completion: @escaping CompletionHandler) -> Request? {
        return networkLayer.downloadFile(downloadURL: downloadURL, filePath: filePath, progress: progress) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.resolve(error: error)))
            }
        }
    }

    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}
