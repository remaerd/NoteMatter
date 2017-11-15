//
//  UINavigationController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class UINavigationController: UIKit.UINavigationController, UINavigationControllerDelegate
{
	var currentEdgeIndicator : EdgeIndicator?
	lazy var leftEdgeIndicator = EdgeIndicator(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.cellHeight), cornerType: .left)
	lazy var rightEdgeIndicator = EdgeIndicator(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.cellHeight), cornerType: .right)

	var leftEdgeGesture : UIScreenEdgePanGestureRecognizer?
	var rightEdgeGesture : UIScreenEdgePanGestureRecognizer?

	lazy var searchBar: SearchBar = SearchBar()
	lazy var slideTransition = SlideTransition(navigationController:self)

	override func loadView()
	{
		super.loadView()
		isNavigationBarHidden = true
		delegate = self
		enableEdgeGesture()
		
		view.addSubview(searchBar)
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchBar.heightAnchor.constraint(equalToConstant: Constants.searchBarHeight).isActive = true
		searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edgeMargin).isActive = true
		searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edgeMargin).isActive = true
		searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.edgeMargin + Constants.statusBarHeight).isActive = true
	}

	func navigationController(_ navigationController: UIKit.UINavigationController,
	                          willShow viewController: UIKit.UIViewController,
	                          animated: Bool)
	{
		guard let newController = viewController as? EnhancedViewController else { return }
		(viewController as? UICollectionViewController)?.customBackButton()
		(viewController as? UIViewController)?.customBackButton()
		
		searchBar.textColor = Theme.colors[6]
		self.searchBar.placeholder = viewController.navigationItem.title
		self.searchBar.navigationItem = viewController.navigationItem
		
		if let delegate = newController.searchDelegate
		{
			searchBar.searchDelegate = delegate
			searchBar.becomeFirstResponder()
		} else
		{
			if searchBar.isFirstResponder { searchBar.resignFirstResponder() }
			searchBar.close()
			searchBar.searchDelegate = nil
		}

		UIView.animate(withDuration: Constants.defaultTransitionDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
		{
			self.view.backgroundColor = newController.backgroundTintColor
			self.searchBar.backgroundColor = Theme.colors[0]
		}, completion: nil)
	}

	func navigationController(_ navigationController: UIKit.UINavigationController,
	                          animationControllerFor operation: UINavigationControllerOperation,
	                          from fromVC: UIKit.UIViewController,
	                          to toVC: UIKit.UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		guard let fromVC = fromVC as? EnhancedViewController else { return nil }
		guard let toVC = toVC as? EnhancedViewController else { return nil }

		if (operation == .push)
		{
			switch toVC.pushTransition
			{
			case .default: return DefaultTransition(direction: .left)
			case .left: return DefaultTransition(direction: .left)
			case .right: return DefaultTransition(direction: .right)
			case .bottom: return DefaultTransition(direction: .bottom)
			default: return nil
			}
		} else if (operation == .pop)
		{
			switch fromVC.popTransition
			{
			case .default: return DefaultTransition(direction: .right)
			case .left: return DefaultTransition(direction: .left)
			case .right: return DefaultTransition(direction: .right)
			case .bottom: return DefaultTransition(direction: .bottom)
			default: return nil
			}
		}
		return nil
	}

	func navigationController(_ navigationController: UIKit.UINavigationController,
	                          interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
	{
		if self.slideTransition.isStarted { return self.slideTransition } else { return nil }
	}
}
