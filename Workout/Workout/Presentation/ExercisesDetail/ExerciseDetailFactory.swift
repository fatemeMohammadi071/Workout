//
//  ExerciseDetailFactory.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

typealias ExerciseDetailFactory = ExerciseDetailViewControllerFactory & ExerciseDetailViewModelFactory

protocol ExerciseDetailViewControllerFactory {
    var exercise: Exercise? { get }
    func makeExerciseDetailViewController(exercise: Exercise) -> ExerciseDetailViewController
}

protocol ExerciseDetailViewModelFactory {
    func makeExerciseDetailViewModel(exercise: Exercise?) -> ExerciseDetailViewModel
}
