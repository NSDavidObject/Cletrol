//
//  ViewController.swift
//  Cletrol
//
//  Created by David Elsonbaty on 2/23/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

class AwesomeListContentViewController: UIViewController, ContentPresenter {

    weak var delegationController: UIViewController?
    static func instance(by coordinator: AnyObject) -> Self {
        return self.init(nibName: nil, bundle: nil)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with: Any?) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .green
    }
}
