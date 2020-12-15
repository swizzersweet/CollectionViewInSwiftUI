//
//  UIView+Utils.swift
//  CarouselExperiment
//
//  Created by Jonathan Menard on 2020-12-08.
//  Copyright © 2020 Jonathan Menard. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

extension UIView {
    func pin(of view: UIView, padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
    }
}
