//
//  UIImageView+Extension.swift
//  Workout
//
//  Created by Fateme on 4/27/1401 AP.
//

import UIKit
import Kingfisher

extension UIImageView {
    @discardableResult
    func setImage(with resource: Resource?,
                  placeholder: Placeholder? = nil,
                  options: KingfisherOptionsInfo? = nil,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        return kf.setImage(with: resource,
                           placeholder: placeholder,
                           options: options,
                           progressBlock: progressBlock,
                           completionHandler: completionHandler)
    }
}
