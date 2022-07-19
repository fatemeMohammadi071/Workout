//
//  NetworkLayer.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation
import Alamofire

protocol Cancellable {
    func cancelRequest()
}

protocol Downloadable {
    func downloadProgress(on queue: DispatchQueue, _ closure: @escaping (Progress) -> Void)
}

typealias Request = Cancellable & Downloadable

extension Alamofire.Request: Request {
    func cancelRequest() {
        cancel()
    }

    func downloadProgress(on queue: DispatchQueue, _ closure: @escaping (Progress) -> Void) {
        downloadProgress(queue: queue, closure: closure)
    }
}

protocol NetworkLayerProtocol {
    @discardableResult
    func request(model: RequestProtocol,
                 completion: @escaping (_ response: Result<Data?, Error>) -> Void) -> Request?
    @discardableResult
    func downloadFile(downloadURL: String,
                      filePath: URL,
                      progress: @escaping ((Progress) -> Void),
                      completion: @escaping (_ response: Result<Data?, Error>) -> Void) -> Request?
}

// swiftlint:disable line_length
class NetworkLayer: NetworkLayerProtocol {
    private var sessionManager: Session!

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        sessionManager = Alamofire.Session(configuration: configuration)
    }

    @discardableResult
    func request(model: RequestProtocol, completion: @escaping (Result<Data?, Error>) -> Void) -> Request? {
        let url = model.baseURL + model.relativePath
        return sessionManager.request(url,
                                      method: model.method,
                                      parameters: model.parameters,
                                      encoding: URLEncoding.default,
                                      headers: HTTPHeaders(model.headers ?? [:]),
                                      interceptor: model.interceptor).validate().response { response in
            let result: Result<Data?, Error> = response.error == nil ? .success(response.data ?? Data()) : .failure(response.error!)
            completion(result)
        }
    }

    func downloadFile(downloadURL: String, filePath: URL, progress: @escaping ((Progress) -> Void), completion: @escaping (_ response: Result<Data?, Error>) -> Void) -> Request? {
        let destination: DownloadRequest.Destination = { (temporaryURL, response)  in
            if response.statusCode == 200 {
                if FileManager.default.fileExists(atPath: filePath.path) {
                    do {
                        try FileManager.default.removeItem(at: filePath)
                    } catch {}
                }
                return (filePath, [])
            } else {
                return (temporaryURL, [])
            }
        }
        return sessionManager.download(downloadURL, to: destination).downloadProgress { prog in
            progress(prog)
        }.responseData { response in
            let result: Result<Data?, Error> = response.error == nil ? .success(response.value ?? Data()) : .failure(response.error!)
            completion(result)
        }
    }
}
