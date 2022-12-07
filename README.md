# Code Review

## An overview of the application development process

In order to explain how I think about developing an application, let me begin with how I think about the whole process. In my opinion, it is better to consider different layers for different parts of the application (data, network, domain, UI, etc.), and this part of the code should be split into two parts (NetworkManager and Data). These layers are explained as follows ( I implemented the NetworkManager and attached it to the email): 

NetworkManager:  
 - Contains generic network requests

Data: 
 - It contains repositories, Data stores. - It is responsible for getting data from data sources whether it is local (DB) or remote (API).
 - Business logic doesn’t know where the data come from. just tell the repository that it needs data and the repo decides where to fetch them.\
 
 
 The different layers do not depend on each other, so writing tests is easy. Meanwhile, it's so easy to use one layer for another project when needed. Furthermore, layering the different parts of the application makes it easy for us to modulate the application whenever we want.


## What should we do in ConversionAPI file
 - Develop a protocol for ConversionAPI. When we want to write unit tests, we need mocks, so this protocol allows us to write mocks easily. However, we should not inject ConversionAPI directly into another layer like the presenter. As a result of dependency injection. It is not a good idea for the presenter layer to be dependent on the data layer and vice versa. we need a bridge between the data layer and the presenter layer that uses the domain layer for this state. It makes the architect clean.
 It is better to inject a network manager into the ConversionAPI instead of using SessionManager directly in it. because of:
 
    - Instead of importing Alamofire into the whole API file, It just imports into the NetworkManager, so whenever we want to update the Alamofire package, we do not need to update the whole API files.
    - It is better to use a network manager to handle all things that are related to the network, for example, error handling.
        
 
  - It is better to have less dependency on the libraries because of updating issues and handling the issues that may be in the libraries.
if PovioKitNetworking is developed by the developer's company It's great, but if not, It is better to have less dependency on the libraries.

 - Using ```async throws String``` instead of ```async -> Result<String, AFError>```

 - Use RequestProtocol which is implemented as below for requests instead of defining base_url, headers, Methode,... into the API files. we can consider an Endpoint for each service that conforms to this protocol and we can define the relative path and the other requirements of an API call into this endpoint and inject it into the service.

 
  - instead of handling tokens in this API call, we should do it in NetworkManager. we need to refresh the token after unauthorizing and every service should not handle this. It's better to handle this situation just once, because of the boilerplate in the code.

  - it is better to use a configuration file that holds the base_url for different requests and add the variables of base_urls into the info.plist. That it develops in AppConfiguration. In this way, whenever we want to add a new URL to the project or if we want to have a different base_url for release or debug

 - progressreport typp, It's better to rename progressReport
 
 - This function dose not obey from single responsibilty:     
    ```swift
     func conversion(provisioningModel: ProvisioningModel, progressreport: ProgressHandler?) async -> Result<String, AFError> {
    ```
    
 - It is not obey from open/close prisinple and we need to handle the different formats that will add in the future.
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
protocol NetworkManagerProtocol {
    typealias CompletionHandler<T> = ((Result<T?, NetworkError>) -> Void)

    func request<T: RequestProtocol, E: Decodable>(_ request: T,
                                                   completion: @escaping CompletionHandler<E>)
    func downloadImage<T: RequestProtocol>(_ request: T,
                                                   completion: @escaping CompletionHandler<Data>)
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
