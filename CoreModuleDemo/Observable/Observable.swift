//
//  Observable.swift
//  CoreModuleDemo
//
//  Created by Mina Atef on 21/06/2023.
//

import Foundation

class Observable<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func observe(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
