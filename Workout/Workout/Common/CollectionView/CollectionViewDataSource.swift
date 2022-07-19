//
//  CollectionViewDataSource.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

protocol ScrollEventProtocols: AnyObject {
    func tableViewBeginsScrolling()
    func tableViewDidScroll(scrollView: UIScrollView)
}

protocol CollectionViewDataSource: UICollectionViewDelegate, UICollectionViewDataSource {
    var sections: [SectionViewModel] {get set}
    var onDataSourceChanged: (() -> Void)? {get set}
    var didSelectCollectionView: ((Any) -> Void)? {get set}
}

// MARK: Default Implementations
class DefaultCollectionViewDataSource: NSObject, CollectionViewDataSource {

    var sections: [SectionViewModel] {
        didSet {
            onDataSourceChanged?()
        }
    }
    weak var scrollEventProtocol: ScrollEventProtocols?
    var onDataSourceChanged: (() -> Void)?
    var didSelectCollectionView: ((Any) -> Void)?

    init(sections: [SectionViewModel]) {
        self.sections = sections
    }
}

extension DefaultCollectionViewDataSource: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sections[section].getHeaderExpanded() {
            let count = sections[section].cells.count
            return count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = sections[indexPath.section].cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellViewModel.reuseId, for: indexPath)
        (cell as? Binder)?.bind(cellViewModel)
        return cell
    }
}

extension DefaultCollectionViewDataSource: UIGestureRecognizerDelegate {
    @objc func handleTap(sender: UIGestureRecognizer) {
        guard let tableView = sender.view?.superview as? UITableView else { return }
        guard let index = sender.view?.tag else { return }
        let isExpanded = sections[index].getHeaderExpanded()
        sections[index].setHeaderExpanded(value: !isExpanded)

        var indexPaths = [IndexPath]()
        for row in sections[index].cells.indices {
            let indexPath = IndexPath(row: row, section: index)
            indexPaths.append(indexPath)
        }

        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .middle)
        } else {
            tableView.insertRows(at: indexPaths, with: .middle)
        }
    }
}
extension DefaultCollectionViewDataSource: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellViewModel = sections[indexPath.section].cells[indexPath.row]
        self.didSelectCollectionView?(cellViewModel)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollEventProtocol?.tableViewBeginsScrolling()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollEventProtocol?.tableViewDidScroll(scrollView: scrollView)
    }

}
