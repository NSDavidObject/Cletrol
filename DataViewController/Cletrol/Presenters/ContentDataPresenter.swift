//
//  ContentPresenter.swift
//  DataViewController
//
//  Created by David Elsonbaty on 2/24/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

// MARK: - Content
public protocol ContentPresenter: Presenter {
    func setup(with: Any?)
}
