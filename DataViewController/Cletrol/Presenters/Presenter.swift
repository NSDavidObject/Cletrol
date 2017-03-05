//
//  Presenter.swift
//  DataViewController
//
//  Created by David Elsonbaty on 2/24/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

public protocol Presenter: class {
    var presentedView: UIView! { get }
    weak var delegationController: UIViewController? { get set }
    static func instance() -> Self
}

public extension Presenter where Self: UIViewController {
    public var presentedView: UIView! {
        return view
    }
}

public extension Presenter where Self: UIView {
    public var presentedView: UIView! {
        return self
    }
}
