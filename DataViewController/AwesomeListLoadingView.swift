//
//  AwesomeListLoadingView.swift
//  DataViewController
//
//  Created by David Elsonbaty on 2/24/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

class AwesomeListLoadingView: UIView, Presenter {
    weak var delegationController: UIViewController?
    var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .yellow
        loadingSpinner.startAnimating()
        loadingSpinner.center = center
        addSubview(loadingSpinner)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadingSpinner.center = center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func instance() -> Self {
        return self.init(frame: .zero)
    }
}
