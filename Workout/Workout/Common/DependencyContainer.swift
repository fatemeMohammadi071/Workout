//
//  DependencyContainer.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

public class DependencyContainer {
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
}

extension DependencyContainer: ExercisesFlowCoordinatorDependencies {

    func makeExercisesDependencyContainer() -> ExercisesDependencyContainer {
        return ExercisesDependencyContainer()
    }

    func makeExerciseDetailDependency() -> ExerciseDetailDependencyContainer {
        return ExerciseDetailDependencyContainer()
    }

    func makeVariationDetailDependency() -> VariationDetailDependencyContainer {
        return VariationDetailDependencyContainer()
    }
}
