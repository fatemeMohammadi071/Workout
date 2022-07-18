//
//  VariationCollectionViewCell.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

class VariationCollectionViewCell: UICollectionViewCell, Binder {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint! {
        didSet {
            self.widthConstraint.constant = (UIScreen.main.bounds.width - 16)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ viewModel: Any) {
        guard let model = (viewModel as? CellViewModel)?.getModel() as? Int else { return }
        titleLabel.text = "Variation \(model)"
    }
}
