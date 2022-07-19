//
//  VariationDetailFactory.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

typealias VariationDetailFactory = VariationDetailViewControllerFactory & VariationDetailViewModelFactory

protocol VariationDetailViewControllerFactory {
    var exercise: Exercise? { get }
    func makeVariationDetailViewController(exercise: Exercise) -> VariationDetailViewController
}

protocol VariationDetailViewModelFactory {
    func makeVariationDetailViewModel(exercise: Exercise?) -> VariationDetailViewModel
}
