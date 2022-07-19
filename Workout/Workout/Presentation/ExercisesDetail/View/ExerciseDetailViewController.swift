//
//  ExerciseDetailViewController.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit
import Combine

protocol ExerciseDetailViewControllerDelegate: AnyObject {
    func exerciseDetailViewController( _ viewController: ExerciseDetailViewController, didSelectItem exercise: Exercise)
}

class ExerciseDetailViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imagesCollectionView: CollectionView!
    @IBOutlet private weak var variationsCollectionView: CollectionView!

    private var factory: ExerciseDetailFactory!
    var viewModel: ExerciseDetailViewModel!
    private var store = Set<AnyCancellable>()
    private var exercise: Exercise?

    weak var delegate: ExerciseDetailViewControllerDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("ExerciseDetailViewController - Initialization using coder Not Allowed.")
    }

    init(factory: ExerciseDetailFactory) {
        super.init(nibName: ExerciseDetailViewController.nibName, bundle: nil)
        self.factory = factory
    }

    deinit {
        print("Deinit ExerciseDetailViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupUI()
        bindViewModelToView(viewModel)
        viewModel.viewDidLoad()
    }

    private func setup() {
        self.viewModel = factory.makeExerciseDetailViewModel(exercise: factory.exercise)
        self.exercise = factory.exercise
    }

    private func setupUI() {
        imagesCollectionView.setScrollDirection(direction: .horizontal)
    }

    private func bindViewModelToView(_ viewModel: ExerciseDetailViewModel) {

        viewModel.name$.sink { [unowned self] name in
            titleLabel.text = name
        }.store(in: &store)

        viewModel.imagesIsEmpty$.sink { [unowned self] isEmpty in
            if isEmpty {
                self.imagesCollectionView.showEmptyListView("Nothing found here", icon: nil, buttonText: nil, backgroundColor: UIColor.systemGray6, buttonTapHandler: nil)
            }
        }.store(in: &store)

        viewModel.variationsIsEmpty$.sink { [unowned self] isEmpty in
            if isEmpty {
                self.variationsCollectionView.showEmptyListView("Nothing found here", icon: nil, buttonText: nil, backgroundColor: UIColor.systemGray6, buttonTapHandler: nil)
            }
        }.store(in: &store)

        viewModel.images$.sink { [unowned self] images in
            let section = createImageSection(model: images)
            displayImages(sections: [section])
        }.store(in: &store)

        viewModel.variations$.sink { [unowned self] variations in
            let section = createVariationsSection(model: variations)
            displayVariations(sections: [section])
        }.store(in: &store)
    }

    // Images Collection
    private func displayImages(sections: [SectionViewModel]) {
        let dataSource = DefaultCollectionViewDataSource(sections: sections)
        self.imagesCollectionView.displayData(dataSource)
    }

    private func createImageSection(model: [Image]) -> SectionViewModel {
        let collectionCells = createImageCells(model: model)
        let collectionSection = DefaultSection(cells: collectionCells)
        return collectionSection
    }

    private func createImageCells(model: [Image]) -> [CellViewModel] {
        return model.map { DefaultCellViewModel(nibName: "ImageCollectionViewCell", reuseId: "ImageCollectionViewCell", model: $0) }
    }

    // Variations Collection
    private func displayVariations(sections: [SectionViewModel]) {
        self.variationsCollectionView.didSelectCollectionView = { _ in
            guard let exercise = self.exercise else { return }
            self.delegate?.exerciseDetailViewController(self, didSelectItem: exercise)
        }
        let dataSource = DefaultCollectionViewDataSource(sections: sections)
        self.variationsCollectionView.displayData(dataSource)
    }

    private func createVariationsSection(model: [Int]) -> SectionViewModel {
        let collectionCells = createVariationsCells(model: model)
        let collectionSection = DefaultSection(cells: collectionCells)
        return collectionSection
    }

    private func createVariationsCells(model: [Int]) -> [CellViewModel] {
        return model.map { DefaultCellViewModel(nibName: "VariationCollectionViewCell", reuseId: "VariationCollectionViewCell", model: $0) }
    }
}
