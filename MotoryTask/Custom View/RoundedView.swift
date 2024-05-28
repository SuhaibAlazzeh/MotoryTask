//
//  RoundedView.swift
//  MotoryTask
//
//  Created by Suhaib Alazzeh on 24/05/2024.
//

import UIKit

@IBDesignable class RoundedView: UIView {

    @IBInspectable var borderColor: UIColor = UIColor.white {
            didSet {
                self.layer.borderColor = borderColor.cgColor
            }
        }

        @IBInspectable var borderWidth: CGFloat = 2.0 {
            didSet {
                self.layer.borderWidth = borderWidth
            }
        }

        @IBInspectable var cornerRadius: CGFloat = 0.0 {
            didSet {
                self.layer.cornerRadius = cornerRadius
            }
        }
}

