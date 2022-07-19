# Workout

## Requirements
- iOS 14.0+
- Xcode 13.2

## Architecture
### MVVM + Clean Architechure
This project has been developed using MVVM + clean architecture. To develop testable and readable code using the different layers of a project, including Domain, Data, and Presentation. The domain is the layer that both of the other layers have a dependency on it. But, there was a dependency inversion between the domain layer and data layer because we were forced to communicate from the data layer to the domain, so I used a protocol to improve it and make the writing test better. As mentioned above, In this architecture we have below parts:

- Presentation: Including view and ViewModel
- Data: Including the network's manager to call our APIs. Infrastructure that is responsible for API calls.
- Domain: Including NetworkLayer. It is the base of our requests and it can be used in any project. Try importing Alamofire only in this layer and not in any other.
- FlowCoordinator: To navigate between different parts of the project
- Dependency Injection Container: to inject dependencies into the modules. It contains Factory that is an initializer injection for viewControllers which sends services in the network layer to the viewModel
