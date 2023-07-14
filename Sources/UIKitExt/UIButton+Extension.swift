//
//  UIButton+Extension.swift
//  CoreExtension
//
//  Created by Lazyman on 3/6/23.
//

import UIKit

public extension UIButton {
    func setTitleColor(_ color: UIColor?, for states: [UIControl.State] = [.normal, .highlighted, .disabled]) {
        states.forEach { state in
            self.setTitleColor(color, for: state)
        }
    }
}
