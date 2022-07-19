//
//  ExercisesFlowCoordinator.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import UIKit

protocol ExercisesFlowCoordinatorDependencies {
    func makeExercisesDependencyContainer() -> ExercisesDependencyContainer
    func makeExerciseDetailDependency() -> ExerciseDetailDependencyContainer
    func makeVariationDetailDependency() -> VariationDetailDependencyContainer
}

final class ExercisesFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: ExercisesFlowCoordinatorDependencies

    init(navigationController: UINavigationController,
         dependencies: ExercisesFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let action = ExercisesViewModelAction(showDetails: showExerciseDetails)
        let exercisesDependency = dependencies.makeExercisesDependencyContainer()
        let exerciseVC = exercisesDependency.makeExercisesViewController(action: action)
        navigationController?.pushViewController(exerciseVC, animated: false)
    }

    private func showExerciseDetails(exercise: Exercise) {
        let exerciseDetailDependency = dependencies.makeExerciseDetailDependency()
        let exerciseDetailVC = exerciseDetailDependency.makeExerciseDetailViewController(exercise: exercise)
        exerciseDetailVC.delegate = self
        navigationController?.pushViewController(exerciseDetailVC, animated: false)
    }
}

extension ExercisesFlowCoordinator: ExerciseDetailViewControllerDelegate {
    func exerciseDetailViewController(_ viewController: ExerciseDetailViewController, didSelectItem exercise: Exercise) {
        let variationDetailDependency = dependencies.makeVariationDetailDependency()
        let variationDetailVC = variationDetailDependency.makeVariationDetailViewController(exercise: exercise)
        navigationController?.pushViewController(variationDetailVC, animated: false)
    }
}
