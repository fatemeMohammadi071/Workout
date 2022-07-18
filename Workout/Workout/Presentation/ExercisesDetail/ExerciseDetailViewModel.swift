//
//  ExerciseDetailViewModel.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import Foundation
import Combine

// swiftlint:disable identifier_name

protocol ExerciseDetailViewModelProtocol {
    // Input
    func viewDidLoad()

    // Output
    var name$: AnyPublisher<String, Never> { get }
    var images$: AnyPublisher<[Image], Never> { get }
    var variations$: AnyPublisher<[Int], Never> { get }
    var imagesIsEmpty$: AnyPublisher<Bool, Never> { get }
    var variationsIsEmpty$: AnyPublisher<Bool, Never> { get }
}

final class ExerciseDetailViewModel: ExerciseDetailViewModelProtocol {

    private var exercise: Exercise?

    lazy var name$: AnyPublisher<String, Never>  = nameSubject.eraseToAnyPublisher()
    lazy var images$: AnyPublisher<[Image], Never>  = imagesSubject.eraseToAnyPublisher()
    lazy var variations$: AnyPublisher<[Int], Never>  = variationsSubject.eraseToAnyPublisher()
    lazy var imagesIsEmpty$: AnyPublisher<Bool, Never>  = imagesIsEmptySubject.eraseToAnyPublisher()
    lazy var variationsIsEmpty$: AnyPublisher<Bool, Never>  = variationsIsEmptySubject.eraseToAnyPublisher()

    private lazy var nameSubject = PassthroughSubject<String, Never>()
    private lazy var imagesSubject = PassthroughSubject<[Image], Never>()
    private lazy var variationsSubject = PassthroughSubject<[Int], Never>()
    private lazy var imagesIsEmptySubject = PassthroughSubject<Bool, Never>()
    private lazy var variationsIsEmptySubject = PassthroughSubject<Bool, Never>()

    init(exercise: Exercise?) {
        self.exercise = exercise
    }

    func viewDidLoad() {

        guard let exercise = exercise else { return }

        if exercise.images.isEmpty {
            imagesIsEmptySubject.send(true)
        } else {
            imagesSubject.send(exercise.images)
        }

        if exercise.variations.isEmpty {
            variationsIsEmptySubject.send(true)
        } else {
            variationsSubject.send(exercise.variations)
        }

        nameSubject.send(exercise.name)
    }
}
