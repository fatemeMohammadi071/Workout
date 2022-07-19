//
//  ExercisesFactory.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import UIKit

// swiftlint:disable line_length
typealias ExercisesFactory = ExercisesViewControllerFactory & ExercisesServiceFactory & ExercisesViewModelFactory & ExercisesFlowCoordinatorFactory

protocol ExercisesViewControllerFactory {
    var action: ExercisesViewModelAction? { get }
    func makeExercisesViewController(action: ExercisesViewModelAction) -> ExercisesViewController
}

protocol ExercisesServiceFactory {
    func makeExercisesService() -> ExercisesService
}

protocol ExercisesViewModelFactory {
    func makeExercisesViewModel(action: ExercisesViewModelAction?) -> ExercisesViewModel
}

protocol ExercisesFlowCoordinatorFactory {
    func makeFlowCoordinator(navigationController: UINavigationController) -> ExercisesFlowCoordinator
}
