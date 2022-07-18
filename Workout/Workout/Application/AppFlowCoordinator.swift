//
//  AppFlowCoordinator.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: DependencyContainer

    init(navigationController: UINavigationController,
         appDIContainer: DependencyContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let exercisesDependencyContainer = appDIContainer.makeExercisesDependencyContainer()
        let flow = exercisesDependencyContainer.makeFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
