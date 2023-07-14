//
//  With.swift
//  CoreExtension
//
//  Created by Lazyman on 1/2/23.
//

import UIKit

public protocol With {}

public extension With where Self: AnyObject {
    @discardableResult
    func with<T>(_ property: ReferenceWritableKeyPath<Self, T>, setTo value: T) -> Self {
        self[keyPath: property] = value
        return self
    }
}

extension UIView: With {}
