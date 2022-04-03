//
//  Box.swift
//  SurveyApp
//
//  Created by sanad barjawi on 02/04/2022.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ val: T) {
        self.value = val
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
