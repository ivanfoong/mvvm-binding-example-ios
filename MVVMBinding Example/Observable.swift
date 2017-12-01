//
//  Observable.swift
//  MVVMBinding Example
//
//  Created by Ivan Foong on 1/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import Foundation

class Observable<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(listener: Listener?) {
        print("bindAndFire")
        self.listener = listener
        listener?(value)
    }
    
    func unbind() {
        self.listener = nil
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
