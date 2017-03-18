//
//  FailurePresenter.swift
//  Cletrol
//
//  Created by David Elsonbaty on 2/24/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import Foundation

// MARK: - Failure
public protocol FailurePresenter: Presenter {
    var delegate: FailurePresenterDelegate? { get set }
    func setup(with: Any, numberOfTries: Int)
}
public protocol FailurePresenterDelegate: class {
    func failureDataViewControllerDidRetry(_ : FailurePresenter)
}
