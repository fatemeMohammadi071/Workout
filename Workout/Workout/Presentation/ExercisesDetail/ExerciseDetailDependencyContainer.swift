//
//  ExerciseDetailDependencyContainer.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

final class ExerciseDetailDependencyContainer: DependencyContainer {
    var exercise: Exercise?}

extension ExerciseDetailDependencyContainer: ExerciseDetailFactory {

    func makeExerciseDetailViewController(exercise: Exercise) -> ExerciseDetailViewController {
        self.exercise = exercise
        return ExerciseDetailViewController(factory: self)
    }

    func makeExerciseDetailViewModel(exercise: Exercise?) -> ExerciseDetailViewModel {
        return ExerciseDetailViewModel(exercise: exercise)
    }
}
