//
//  ExercisesViewController.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit
import Combine

class ExercisesViewController: UIViewController {

    @IBOutlet private weak var collectionView: CollectionView!

    private var factory: ExercisesFactory!
    private var viewModel: ExercisesViewModel!
    private var store = Set<AnyCancellable>()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("ExercisesViewController - Initialization using coder Not Allowed.")
    }

    init(factory: ExercisesFactory) {
        super.init(nibName: ExercisesViewController.nibName, bundle: nil)
        self.factory = factory
    }

    deinit {
        print("Deinit ExercisesViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupView()
        bindViewModelToView(viewModel)
        viewModel.getExercises()
    }

    private func setup() {
        self.viewModel = factory.makeExercisesViewModel(action: factory.action)
    }

    private func setupView() {}

    private func bindViewModelToView(_ viewModel: ExercisesViewModel) {
        viewModel.error$.sink { [unowned self] error in
            displayError(error: error)
        }.store(in: &store)

        viewModel.items$.sink { [unowned self] exercises in
            let section = createSection(model: exercises)
            displayList(sections: [section])
        }.store(in: &store)

        viewModel.isLoading$.sink { [unowned self] isLoading in
            self.displayLoading(isLoading: isLoading)
        }.store(in: &store)

        viewModel.isEmptyList$.sink { [unowned self] isEmpty in
            if isEmpty {
                self.collectionView.showEmptyListView("Nothing found here", icon: nil, buttonText: nil, backgroundColor: UIColor.lightGray, buttonTapHandler: nil)
            }
        }.store(in: &store)
    }

    private func displayError(error: Error) {
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel?.getExercises()
        }
        self.presentMessege(title: "Error", message: error.localizedDescription, additionalActions: okAction, retryAction, preferredStyle: .alert)
    }

    private func displayList(sections: [SectionViewModel]) {
        let dataSource = DefaultCollectionViewDataSource(sections: sections)
        self.collectionView.didSelectCollectionView = { (viewModel) in
            guard let exercise = (viewModel as? CellViewModel)?.getModel() as? Exercise else {
                return
            }
            self.viewModel.didSelectItem(exercise)
        }
        self.collectionView.displayData(dataSource)
    }

    private func displayLoading(isLoading: Bool) {
        if isLoading {
            view.showLoading()
        } else {
            view.hideLoading()
        }
    }

    private func createSection(model: [Exercise]) -> SectionViewModel {
        let collectionCells = createCells(model: model)
        let collectionSection = DefaultSection(cells: collectionCells)
        return collectionSection
    }

    private func createCells(model: [Exercise]) -> [CellViewModel] {
        return model.map { DefaultCellViewModel(nibName: "ExreciseCollectionViewCell", reuseId: "ExreciseCollectionViewCell", model: $0) }
    }
}
