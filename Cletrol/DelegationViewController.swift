//
//  DelegationViewController.swift
//  Cletrol
//
//  Created by David Elsonbaty on 2/23/17.
//  Copyright © 2017 David Elsonbaty. All rights reserved.
//

import UIKit

public enum DelegatorState {
    case instantiated
    case loading(Presenter)
    case failure(FailurePresenter)
    case succeeded(ContentPresenter)
}

public class DelegationViewController<C: PresentationCoordinator>: UIViewController {
    
    public fileprivate(set) var loadingController: Presenter?
    public fileprivate(set) var contentController: ContentPresenter?
    public fileprivate(set) var failureController: FailurePresenter?

    fileprivate var coordinator: C
    fileprivate var numberOfRetries = 0
    fileprivate var state: DelegatorState = .instantiated {
        didSet {
            didSwitchState(from: oldValue, to: state)
        }
    
    }

    public var presentedPresenter: Presenter? {
        switch state {
        case .instantiated: return nil
        case .loading(let controller): return controller
        case .failure(let controller): return controller
        case .succeeded(let controller): return controller
        }
    }
    public init(coordinator: C) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadingControllerClass = coordinator.loadingControllerClass {
            let loadingController = loadingControllerClass.instance(by: coordinator)
            loadingController.delegationController = self
            loadData(with: loadingController)
        } else {
            let contentController = coordinator.contentControllerClass.instance(by: coordinator)
            contentController.delegationController = self
            contentController.setup(with: nil)
            state = .succeeded(contentController)
        }
    }

    fileprivate func loadData(with loadingController: Presenter) {
        state = .loading(loadingController)
        coordinator.loadData(completion: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            if strongSelf.coordinator.isFailure(result) {
                guard let failureControllerClass = strongSelf.coordinator.failureControllerClass else {
                    fatalError("Must provide failure presenter if loading controller presenter is provided and data loading might fail")
                }
                
                let failureController = failureControllerClass.instance(by: strongSelf.coordinator)
                failureController.delegationController = self
                failureController.delegate = strongSelf
                failureController.setup(with: result, numberOfTries: strongSelf.numberOfRetries)
                strongSelf.state = .failure(failureController)
            } else {
                let contentController = strongSelf.coordinator.contentControllerClass.instance(by: strongSelf.coordinator)
                contentController.delegationController = self
                if #available(iOS 9.0, *) {
                    (contentController as? UIViewController)?.loadViewIfNeeded()
                }
                contentController.setup(with: result)
                strongSelf.state = .succeeded(contentController)
            }
        })
    }
}

extension DelegationViewController: FailurePresenterDelegate {
    
    public func failureDataViewControllerDidRetry(_: FailurePresenter) {
        guard let loadingController = loadingController else { fatalError() }

        numberOfRetries += 1
        loadData(with: loadingController)
    }
}

fileprivate extension DelegationViewController {
    
    func didSwitchState(from: DelegatorState, to: DelegatorState) {
        switch from {
        case .instantiated:
            switch to {
            case .loading(let loadingController): instantiate(withLoadingController: loadingController)
            case .succeeded(let contentController): instantiate(withContentController: contentController)
            default: fatalError()
            }
        case .loading(let loadingController):
            switch to {
            case .failure(let failureController): handleSwitch(fromLoadingController: loadingController, toFailureController: failureController)
            case .succeeded(let contentController): handleSwitch(fromLoadingController: loadingController, toContentController: contentController)
            default: fatalError()
            }
        case .failure(let failureController):
            switch to {
            case .loading(let loadingController): handleSwitch(fromFailureController: failureController, toLoadingController: loadingController)
            default: fatalError()
            }
            
        default: fatalError()
        }
    }
    
    func instantiate(withLoadingController loadingController: Presenter) {
        self.loadingController = loadingController
        switchMainPresenter(to: loadingController)
    }
    
    func instantiate(withContentController contentController: ContentPresenter) {
        self.contentController = contentController
        switchMainPresenter(to: contentController)
    }
    
    func handleSwitch(fromLoadingController loadingController: Presenter, toContentController contentController: ContentPresenter) {
        self.loadingController = nil
        
        self.contentController = contentController
        switchMainPresenter(from: loadingController, to: contentController)
    }
    
    func handleSwitch(fromLoadingController loadingController: Presenter, toFailureController failureController: FailurePresenter) {
        self.failureController = failureController
        switchMainPresenter(from: loadingController, to: failureController)
    }
    
    func handleSwitch(fromFailureController failureController: FailurePresenter, toLoadingController loadingController: Presenter) {
        self.failureController = nil

        self.loadingController = loadingController
        switchMainPresenter(from: failureController, to: loadingController)
    }
    
    func switchMainPresenter(from oldPresenter: Presenter? = nil, to newPresenter: Presenter) {

        let newView = newPresenter.presentedView
        let setupNewView = {
            newView.frame = self.view.bounds
            newView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(newView)
        }

        if let newViewController = newPresenter as? UIViewController {
            addChildViewController(newViewController)
            setupNewView()
            newViewController.didMove(toParentViewController: self)
        } else {
            setupNewView()
        }

        coordinator.transitionAnimator.animateTransition(from: oldPresenter, to: newPresenter) {
            if let newViewController = newPresenter as? UIViewController {
                newViewController.didMove(toParentViewController: self)
            }

            if let oldViewController = oldPresenter as? UIViewController {
                oldViewController.willMove(toParentViewController: nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.didMove(toParentViewController: nil)
            } else {
                oldPresenter?.presentedView.removeFromSuperview()
            }
        }
    }
}
