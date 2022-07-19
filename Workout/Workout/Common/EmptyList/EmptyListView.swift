//
//  EmptyListView.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit

protocol EmptyListViewProtocol {
    func setEmptyText(_ text: String?)
    func configureButton(_ text: String?, onTapHandler: (() -> Void)?)
}

class EmptyListView: UIView {
    @IBOutlet private weak var emptyText: UILabel! {
        didSet {
            self.emptyText.textColor = UIColor.darkGray
        }
    }
    @IBOutlet private weak var imageContainer: UIView! {
        didSet {
            self.imageContainer.isHidden = true
        }
    }

    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var buttonContainer: UIView! {
        didSet {
            self.buttonContainer.isHidden = true
        }
    }
}

extension EmptyListView: EmptyListViewProtocol {
    func setEmptyText(_ text: String?) {
        self.emptyText.text = text
    }

    func configureButton(_ text: String?, onTapHandler: (() -> Void)?) {
        self.buttonContainer.isHidden = text == nil
        self.button.setTitle(text, for: .normal)
    }
}
