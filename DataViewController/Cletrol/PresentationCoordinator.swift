//
//  PresentationCoordinator.swift
//  DataViewController
//
//  Created by David Elsonbaty on 2/23/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

// MARK: - Coordinator

public protocol PresentationCoordinator: class {
    associatedtype ResultType
    
    var contentControllerClass: ContentPresenter.Type { get }
    var loadingControllerClass: Presenter.Type? { get }
    var failureControllerClass: FailurePresenter.Type? { get }
    
    func loadData(completion: @escaping ((ResultType) -> Void))
    func isFailure(_ result: ResultType) -> Bool
}
