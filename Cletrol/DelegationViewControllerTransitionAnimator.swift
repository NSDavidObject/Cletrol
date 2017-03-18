//
//  DelegationViewControllerAnimatedTransitioning.swift
//  Cletrol
//
//  Created by David Elsonbaty on 2/26/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

public final class DelegationViewControllerTransitionAnimator {

    private static let defaultAnimationDuration: TimeInterval = 0.5

    public init() {}
    public var animationDuration: TimeInterval = DelegationViewControllerTransitionAnimator.defaultAnimationDuration
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
