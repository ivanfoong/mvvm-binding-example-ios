//
//  Observable.swift
//  MVVMBinding Example
//
//  Created by Ivan Foong on 1/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import Foundation

class Observable<T> {
    typealias ObservableListener = (T) -> Void
    private var listeners: [AnyHashable: ObservableListener] = [:]
    
    func bind(for context: AnyHashable, initialFire: Bool = false, with listener: ObservableListener?) {
        self.listeners[context] = listener
        if initialFire {
            listener?(value)
        }
    }
    
    func unbind(for context: AnyHashable) {
        self.listeners.removeValue(forKey: context)
    }
    
    var value: T {
        didSet {
            // TODO @ivanfoong: not to fire listener if value did not change
            self.listeners.values.forEach { listener in
                listener(value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
}
