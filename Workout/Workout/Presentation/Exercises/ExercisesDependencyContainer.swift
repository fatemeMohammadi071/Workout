//
//  ExercisesDependencyContainer.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import UIKit

final class ExercisesDependencyContainer: DependencyContainer {
    var action: ExercisesViewModelAction?
}

extension ExercisesDependencyContainer: ExercisesFactory {

    func makeExercisesViewController(action: ExercisesViewModelAction) -> ExercisesViewController {
        self.action = action
        return ExercisesViewController(factory: self)
    }

    func makeExercisesService() -> ExercisesService {
        return ExercisesService(networkManager: networkManager)
    }

    func makeExercisesViewModel(action: ExercisesViewModelAction?) -> ExercisesViewModel {
        return ExercisesViewModel(service: makeExercisesService(), action: action)
    }

    func makeFlowCoordinator(navigationController: UINavigationController) -> ExercisesFlowCoordinator {
        return ExercisesFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
