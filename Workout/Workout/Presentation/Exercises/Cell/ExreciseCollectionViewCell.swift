//
//  ExreciseCollectionViewCell.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

class ExreciseCollectionViewCell: UICollectionViewCell, Binder {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var exerciseImage: UIImageView!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint! {
        didSet {
            self.widthConstraint.constant = (UIScreen.main.bounds.width - 16)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ viewModel: Any) {
        guard let model = (viewModel as? CellViewModel)?.getModel() as? Exercise else { return }
        titleLabel.text = model.name
        exerciseImage.setImage(with: model.images.first?.image, placeholder: UIImage(named: "workout"))
    }
}
