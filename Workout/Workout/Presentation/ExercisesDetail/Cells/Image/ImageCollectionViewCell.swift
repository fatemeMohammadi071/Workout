//
//  ImageCollectionViewCell.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell, Binder {

    @IBOutlet private var image: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ viewModel: Any) {
        guard let model = (viewModel as? CellViewModel)?.getModel() as? Image else { return }
        image.setImage(with: model.image, placeholder: UIImage(named: "workout"))
    }
}
