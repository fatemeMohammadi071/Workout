//
//  CellViewModel.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import Foundation

protocol CellViewModel {
    var nibName: String {get}
    var reuseId: String {get}
    func getModel() -> Any?
    func setModel(model: Any?)
}

protocol Binder {
    func bind(_ viewModel: Any)
}
extension Binder {
    func willDisplay(_ viewModel: Any) { }
}

class DefaultCellViewModel: CellViewModel {
    var nibName: String
    var reuseId: String
    var model: Any?

    internal init(nibName: String, reuseId: String, model: Any?) {
        self.nibName = nibName
        self.reuseId = reuseId
        self.model = model
    }

    func getModel() -> Any? {
        return model
    }

    func setModel(model: Any?) {
        self.model = model
    }
}

class DefaultCollectionTableCellViewModel {}
