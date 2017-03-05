//
//  AwesomeListCoordinator.swift
//  DataViewController
//
//  Created by David Elsonbaty on 2/24/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import Foundation

class AwesomeListCoordinator: PresentationCoordinator {
    typealias Result = ResultType<Int>
    
    static let errorMessages = ["Looks like you have a bad connection :(", "Umm can someone restart the WIFI?!", "RAGEEE!!!"]
    
    var contentControllerClass: ContentPresenter.Type = AwesomeListContentViewController.self
    var loadingControllerClass: Presenter.Type? = AwesomeListLoadingView.self
    var failureControllerClass: FailurePresenter.Type? = GeneralFailureController.self
    
    var numOfTries = 0
    
    func loadData(completion: @escaping ((Result) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            guard let strongSelf = self, AwesomeListCoordinator.errorMessages.count > strongSelf.numOfTries else {
                completion(.content(0))
                return
            }
            completion(.error(AwesomeListCoordinator.errorMessages[strongSelf.numOfTries]))
            strongSelf.numOfTries += 1
        }
    }
    
    func isFailure(_ result: Result) -> Bool {
        return result.errorMessage != nil
    }
}

