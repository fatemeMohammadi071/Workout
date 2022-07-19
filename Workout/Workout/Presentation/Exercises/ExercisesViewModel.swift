//
//  ExercisesViewModel.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import Foundation
import Combine

// swiftlint:disable identifier_name

struct ExercisesViewModelAction {
    let showDetails: (Exercise) -> Void
}

protocol ExercisesViewModelProtocol {
    // Input
    func getExercises()
    func didSelectItem(_ item: Exercise)

    // Output
    var error$: AnyPublisher<Error, Never> { get }
    var items$: AnyPublisher<[Exercise], Never> { get }
    var isEmptyList$: AnyPublisher<Bool, Never> { get }
    var isLoading$: AnyPublisher<Bool, Never> { get }
}

final class ExercisesViewModel: ExercisesViewModelProtocol {

    private let service: ExercisesService
    private let action: ExercisesViewModelAction?

    lazy var error$: AnyPublisher<Error, Never>  = errorSubject.eraseToAnyPublisher()
    lazy var items$: AnyPublisher<[Exercise], Never>  = itemsSubject.eraseToAnyPublisher()
    lazy var isEmptyList$: AnyPublisher<Bool, Never>  = isEmptyListSubject.eraseToAnyPublisher()
    lazy var isLoading$: AnyPublisher<Bool, Never>  = isLoadingSubject.eraseToAnyPublisher()

    private lazy var errorSubject = PassthroughSubject<Error, Never>()
    private lazy var itemsSubject = PassthroughSubject<[Exercise], Never>()
    private lazy var isEmptyListSubject = PassthroughSubject<Bool, Never>()
    private lazy var isLoadingSubject = PassthroughSubject<Bool, Never>()

    init(service: ExercisesService, action: ExercisesViewModelAction? = nil) {
        self.service = service
        self.action = action
    }

    func getExercises() {
        isLoadingSubject.send(true)
        service.getExercises { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let exercises):
                guard let result = exercises?.results else {
                    self.isEmptyListSubject.send(true)
                    return
                }
                self.itemsSubject.send(result)
            case .failure(let error):
                self.errorSubject.send(error)
            }
            self.isLoadingSubject.send(false)
        }
    }

    func didSelectItem(_ item: Exercise) {
        action?.showDetails(item)
    }
}

private extension ExercisesViewModel {
    func handle(error: Error) {}
}
