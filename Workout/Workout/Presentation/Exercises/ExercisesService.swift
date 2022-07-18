//
//  ExercisesService.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

protocol ExercisesServiceProtocol {
    func getExercises(completion: @escaping (Result<Exercises?, Error>) -> Void)
    func getExercisesImage(exerciseId: Int, completion: @escaping (Result<Data?, Error>) -> Void)
}

final class ExercisesService {

    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension ExercisesService: ExercisesServiceProtocol {
    func getExercises(completion: @escaping (Result<Exercises?, Error>) -> Void) {
        _ = networkManager.request(ExercisesEndPoint.getExercises) { (result) in
            switch result {
            case .success(let data):
                let interactor = Interactor<Exercises>()
                guard let data = data, let model = interactor.parse(data: data) else { return }
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getExercisesImage(exerciseId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        _ = networkManager.request(ExercisesEndPoint.getExercisesImage(exerciseId: exerciseId), completion: { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
