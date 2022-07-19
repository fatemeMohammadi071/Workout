//
//  VariationDetailDependencyContainer.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

final class VariationDetailDependencyContainer: DependencyContainer {
    var exercise: Exercise?
}

extension VariationDetailDependencyContainer: VariationDetailFactory {

    func makeVariationDetailViewController(exercise: Exercise) -> VariationDetailViewController {
        self.exercise = exercise
        return VariationDetailViewController(factory: self)
    }

    func makeVariationDetailViewModel(exercise: Exercise?) -> VariationDetailViewModel {
        return VariationDetailViewModel(exercise: exercise)
    }
}
