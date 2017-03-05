//
//  DelegationViewControllerAnimatedTransitioning.swift
//  DataViewController
//
//  Created by David Elsonbaty on 2/26/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

public protocol DelegationViewControllerTransitionAnimator {

    weak var delegationController: UIViewController? { get }
    func animateTransition(from currentPresenter: Presenter?, to newPresenter: Presenter, completion: @escaping ((Void) -> Void))
}

public final class DelegationViewControllerCrosFadeTransitionAnimator: DelegationViewControllerTransitionAnimator {

    private static let defaultAnimationDuration: TimeInterval = 0.5

    public var animationDuration: TimeInterval = DelegationViewControllerCrosFadeTransitionAnimator.defaultAnimationDuration
    public weak var delegationController: UIViewController?
    public func animateTransition(from currentPresenter: Presenter?, to newPresenter: Presenter, completion: @escaping ((Void) -> Void)) {
        guard let currentPresenter = currentPresenter else {
            completion()
            return
        }

        newPresenter.presentedView.alpha = 0.0
        UIView.animate(withDuration: animationDuration, animations: {
            currentPresenter.presentedView.alpha = 0.0
            newPresenter.presentedView.alpha = 1.0
        }) { _ in
            completion()
        }
    }
}
