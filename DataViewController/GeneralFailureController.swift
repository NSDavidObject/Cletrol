//
//  GeneralFailureController.swift
//  DataViewController
//
//  Created by David Elsonbaty on 2/24/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

enum ResultType<T> {
    case content(T)
    case error(String)
    
    var errorMessage: String? {
        guard case let .error(message) = self else { return nil }
        return message
    }
}

class GeneralFailureController: UIViewController, FailurePresenter {
    var delegate: FailurePresenterDelegate?
    var errorDescriptionLabel = UILabel()
    weak var delegationController: UIViewController?
    static func instance() -> Self {
        return self.init(nibName: nil, bundle: nil)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        errorDescriptionLabel.textColor = .white
        errorDescriptionLabel.textAlignment = .center
        errorDescriptionLabel.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 300)
        view.addSubview(errorDescriptionLabel)
        
        let retryButton = UIButton(type: .custom)
        retryButton.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 300)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        retryButton.center = view.center
        view.addSubview(retryButton)
    }
    
    @objc func didTapRetry() {
        delegate?.failureDataViewControllerDidRetry(self)
    }
    
    func setup(with result: Any, numberOfTries: Int) {
        guard let result = result as? ResultType<Int>, let errorMessage = result.errorMessage else { fatalError() }
        errorDescriptionLabel.text = errorMessage
    }
}
