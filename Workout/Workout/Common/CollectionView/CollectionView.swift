//
//  CollectionView.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

class CollectionView: UICollectionView {

    var sections = [SectionViewModel]()
    var customDataSource: CollectionViewDataSource! {
        didSet {
            self.customDataSource.onDataSourceChanged = { [weak self] in
                guard let self = self else {return}
                self.sections = self.customDataSource.sections
                self.onDataSourceChanged?()
            }

            self.customDataSource.didSelectCollectionView = { [weak self] model in
                guard let self = self else {return}
                self.didSelectCollectionView?(model)
            }
        }
    }
    lazy var emptyListView: EmptyListView = {
        EmptyListView.loadFromNib()
    }()
    var flowLayout = UICollectionViewFlowLayout()
    var onDataSourceChanged: (() -> Void)?
    var didSelectCollectionView: ((Any) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupFlowLayout()
    }

    private func setup() {
        self.backgroundColor = UIColor.clear
    }

    func setupSectionInset(inset: UIEdgeInsets = .init(top: 0, left: 24, bottom: 0, right: 24)) {
        flowLayout.sectionInset = inset
    }

    private func setupFlowLayout() {
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.sectionInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 8.0

        self.collectionViewLayout = flowLayout
    }

    public func setScrollDirection(direction: UICollectionView.ScrollDirection) {
        (self.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = direction
    }

    func displayData(_ dataSource: CollectionViewDataSource) {
        self.customDataSource = dataSource
        self.sections = customDataSource.sections
        registerSectionAndCells(sections: self.sections)
        self.dataSource = customDataSource
        self.delegate = customDataSource
        self.reloadData()
    }

    func reloadData(sections: [SectionViewModel]) {
        self.sections = sections
        self.customDataSource.sections = sections
        self.reloadData()
    }

    func registerSectionAndCells(sections: [SectionViewModel]) {
        sections.forEach { (section) in
            section.cells.forEach { (cell) in
                self.register(UINib.init(nibName: cell.nibName, bundle: .main), forCellWithReuseIdentifier: cell.reuseId)
            }
        }
    }

    func appendCells(cells: [CellViewModel], sectionIndex: Int) {
        let startIndexPath = self.customDataSource.sections[sectionIndex].cells.count
        let endIndexPath = startIndexPath + cells.count
        self.customDataSource.sections[sectionIndex].appendCells(cells: cells)
        self.sections = self.customDataSource.sections
        var indices = [IndexPath]()
        for index in startIndexPath..<endIndexPath {
            indices.append(.init(item: index, section: sectionIndex))
        }
        self.performBatchUpdates({ [weak self] in
            self?.insertItems(at: indices)
        }, completion: nil)
    }

    func showEmptyListView(_ text: String?, icon: UIImage? = nil, buttonText: String? = nil, backgroundColor: UIColor? = nil, buttonTapHandler: (() -> Void)? = nil) {
        self.backgroundView = self.emptyListView
        self.emptyListView.setEmptyText(text)
        self.emptyListView.backgroundColor = backgroundColor ?? .white
        self.emptyListView.configureButton(buttonText) {
            buttonTapHandler?()
        }
    }

    func hideEmptyListView() {
        self.backgroundView = nil
    }

    func isTableViewEmpty() -> Bool {
        if self.sections.isEmpty || (self.sections.first?.cells.isEmpty ?? true) {
            return true
        } else {
            return false
        }
    }
}
