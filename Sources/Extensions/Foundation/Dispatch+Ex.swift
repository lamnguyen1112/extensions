//
//  Dispatch+Ex.swift
//  CoreExtension
//
//  Created by Lazyman on 12/19/22.
//

import Foundation

public func runInMain(execute work: @escaping @convention(block) () -> Swift.Void) {
    DispatchQueue.main.async {
        work()
    }
}

public func delay(seconds: Double, execute work: @escaping @convention(block) () -> Swift.Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        DispatchQueue.main.async {
            work()
        }
    }
}
