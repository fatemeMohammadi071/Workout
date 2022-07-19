//
//  VariationDetailViewController.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit
import Combine

class VariationDetailViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!

    private var factory: VariationDetailFactory!
    var viewModel: VariationDetailViewModel!
    private var store = Set<AnyCancellable>()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("VariationDetailViewController - Initialization using coder Not Allowed.")
    }

    init(factory: VariationDetailFactory) {
        super.init(nibName: VariationDetailViewController.nibName, bundle: nil)
        self.factory = factory
    }

    deinit {
        print("Deinit VariationDetailViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindViewModelToView(viewModel)
        viewModel.viewDidLoad()
    }

    private func setup() {
        self.viewModel = factory.makeVariationDetailViewModel(exercise: factory.exercise)
    }

    private func bindViewModelToView(_ viewModel: VariationDetailViewModel) {

        viewModel.exercise$.sink { [unowned self] exercise in
            titleLabel.text = exercise.name
            descriptionLabel.text = exercise.resultDescription
            categoryLabel.text = exercise.category.name
        }.store(in: &store)
    }
}
