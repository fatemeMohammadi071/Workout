//
//  Interactor.swift
//  Workout
//
//  Created by Fateme on 4/26/1401 AP.
//

import Foundation

class Interactor<Model: Codable>: Parsable {
    typealias Object = Model
    func parse(data: Data) -> Model? {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(Model.self, from: data)
            return model
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
