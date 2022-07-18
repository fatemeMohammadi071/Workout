//
//  VariationDetailViewModel.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import Foundation
import Combine

// swiftlint:disable identifier_name

protocol VariationDetailViewModelProtocol {
    // Input
    func viewDidLoad()

    // Output
    var exercise$: AnyPublisher<Exercise, Never> { get }
}

final class VariationDetailViewModel: VariationDetailViewModelProtocol {

    private var exercise: Exercise?

    lazy var exercise$: AnyPublisher<Exercise, Never>  = exerciseSubject.eraseToAnyPublisher()
    private lazy var exerciseSubject = PassthroughSubject<Exercise, Never>()

    init(exercise: Exercise?) {
        self.exercise = exercise
    }

    func viewDidLoad() {

        guard let exercise = exercise else { return }
        exerciseSubject.send(exercise)
    }
}
