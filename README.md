# Code Review

## An overview of the application development process

In order to explain how I think about developing an application, let me begin with how I think about the whole process. In my opinion, it is better to consider different layers for different parts of the application (data, network, domain, UI, etc.), and this part of the code should be split into two parts (NetworkManager and Data). These layers are explained as follows ( I implemented the NetworkManager and attached it to the email): 

- NetworkManager:  
  - Contains generic network requests

- Data: 
   - It contains repositories, Data stores. - It is responsible for getting data from data sources whether it is local (DB) or remote (API).
   - Business logic doesn’t know where the data come from. just tell the repository that it needs data and the repo decides where to fetch them.\
 
 
 The different layers do not depend on each other, so writing tests is easy. Meanwhile, it's so easy to use one layer for another project when needed. Furthermore, layering the different parts of the application makes it easy for us to modulate the application whenever we want.


## What should we do in ConversionAPI file
I am going to address some points bellow:

 - Develop a protocol for ConversionAPI. When we want to write unit tests, we need mocks, so this protocol allows us to write mocks easily. However, we should not inject ConversionAPI directly into another layer like the presenter. As a result of dependency injection. It is not a good idea for the presenter layer to be dependent on the data layer and vice versa. we need a bridge between the data layer and the presenter layer that uses the domain layer for this state. It makes the architect clean.
  Instead of using SessionManager directly in the ConversionAPI, it would be better to inject a network manager.
 
 - Rather than importing Alamofire into the whole APIs file, it only imports into the NetworkManager, so whenever we update Alamofire, we don't need to update the whole APIs file.

 - All network-related things, such as error handling, are better handled by a NetworkManager.
 
  - Less dependency on libraries is better because of updating issues and handling library issues.if PovioKitNetworking is developed by the developer's company It's great, otherwise less dependency on libraries is better.

 - Using ```async throws String``` instead of ```async -> Result<String, AFError>```

 - Instead of defining base_url, headers, methods, etc., into API files, use RequestProtocol which is implemented as follows We can consider an Endpoint for each service that conforms to this protocol and determine the relative path and the other requirements of an API call into this endpoint and inject it into the service.

 
  - instead of handling tokens in this API call, we should do it in NetworkManager. we need to refresh the token after unauthorizing and every service should not handle this. It's better to handle this situation just once, because of the boilerplate in the code.

  - it is better to use a configuration file that holds the base_url for different requests and add the variables of base_urls into the info.plist. That it develops in AppConfiguration. In this way, whenever we want to add a new URL to the project or if we want to have a different base_url for release or debug

 - ```progressreport```  is better to rename ```progressReport```
 
 - conversion function does not obey single responsibility.   
    
 - This part of code does not to obey from open/close principle and we need to handle the different formats that will add in the future.
    ```swift
    if let imageData = provisioningModel.mPhoto {
      // check image type
        
      if imageData.startsWith(startBytes: "ffd8dde0") {
        // jpeg
        data.jpegImage = imageData
        Logger.debug("mP \(data.jpegImage.count.withCommas()) bytes")
      } else if imageData.startsWith(startBytes: "47494638") {
        // gif
        data.gifImage = imageData
        Logger.debug("mP \(data.gifImage.count.withCommas()) bytes")
      }
      // TODO: what other images do we need?
    }

    if let videoData = provisioningModel.eVideo {
      data.video = videoData
      Logger.debug("video data: \(videoData)")
    }
    ```
## Implemented Codes

### RequestProtocol

```swift
import Foundation

/// Managing all stuff that related to the request into the RequestProtocol
enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
}

public struct FormData {

    public enum FormDataProvider {
        case data(Foundation.Data)
        case file(URL)
        case stream(InputStream, UInt64)
    }

    public init(provider: FormDataProvider, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.provider = provider
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

    public let provider: FormDataProvider
    public let name: String
    public let fileName: String?
    public let mimeType: String?

}

public enum RequestType {
    case requestPlain
    case requestJSONEncodable(Encodable)
    case requestParameters(urlParameters: [String: Any])
    case uploadCompositeMultipart([FormData], urlParameters: [String: Any]?)
    case uploadFile(URL)
}

public protocol RequestProtocol {
    var baseURL: String {get}
    var relativePath: String {get}
    var method: HTTPMethods {get}
    var headers: [String: String]? {get}
    var parameters: [String: Any]? {get}
}

extension RequestProtocol {
    var baseURL: String {
        return AppConfiguration().apiBaseURL
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var parameters: [String: Any]? {
        return [:]
    }

    var method: HTTPMethods {
        return .get
    }
}
```


### NetworkManager

```swift
enum NetworkError: Error {
    case notConnected
    case cancelled
    case generic(Error)
    case parsing(Error)
    case noResponse
    case error(statusCode: Int, data: Data?)
}

protocol Cancellable {
    func cancelRequest()
}

extension URLSessionDataTask: Cancellable {
    func cancelRequest() {
        cancel()
    }
}

protocol NetworkLayerProtocol {
    @discardableResult
    func request(model: RequestProtocol,
                 completion: @escaping (_ response: Result<Data?, NetworkError>) -> Void) -> Cancellable?
}

typealias DataTaskResult = Result<Data?, NetworkError>

class NetworkLayer: NetworkLayerProtocol {

    var dataTask: URLSessionDataTask?

    private let sessionManager: NetworkSessionManagerProtocol

    init(sessionManager: NetworkSessionManagerProtocol = NetworkSessionManager()) {
        self.sessionManager = sessionManager
    }

    @discardableResult
    func request(model: RequestProtocol, completion: @escaping (DataTaskResult) -> Void) -> Cancellable? {
        dataTask?.cancel()
        guard let url = URL(string: model.baseURL + model.relativePath) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = model.method.rawValue
        let dataTask = sessionManager.request(request) { (data,response,error)   in
            // TODO: Handle response and error
        }
        return dataTask
    }

    private func resolve(error: Error, response: HTTPURLResponse? = nil) -> NetworkError {
        // TODO: Convert error to custom error
    }
}
```

### AppConfiguration

```swift
// AppConfiguration to handle the apiBaseURL
final class AppConfiguration {
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
}
```
