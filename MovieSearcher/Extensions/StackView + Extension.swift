//
//  StackView + Extension.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

extension UIStackView {
    func addArrangeSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
