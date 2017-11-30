//
//  UINavigationController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Cartography

class UINavigationController: UIKit.UINavigationController, UINavigationControllerDelegate
{
	var leftEdgeGesture : UIScreenEdgePanGestureRecognizer?
	var rightEdgeGesture : UIScreenEdgePanGestureRecognizer?

	lazy var searchBar: SearchBar = SearchBar()
	lazy var slideTransition = SlideTransition(navigationController:self)

	override func loadView()
	{
		super.loadView()
		isNavigationBarHidden = true
		delegate = self
		
		view.addSubview(searchBar)
		
		constrain(searchBar)
		{
			searchBar in
			searchBar.height == Constants.searchBarHeight
			searchBar.leading == searchBar.superview!.leading + Constants.edgeMargin
			searchBar.trailing == searchBar.superview!.trailing - Constants.edgeMargin
			searchBar.top == searchBar.superview!.top + Constants.edgeMargin + Constants.statusBarHeight
		}
	}
	
	// 解决一个因 ModalViewController 和 UICollectionViewController 之间滚动会出现的 BUG
	override func present(_ viewControllerToPresent: UIKit.UIViewController, animated flag: Bool, completion: (() -> Void)? = nil)
	{
		if let controller = visibleViewController as? UICollectionViewController, let view = controller.collectionView, let items = view.indexPathsForSelectedItems, items.count != 0
		{
			view.deselectItem(at: items[0], animated: false)
		}
		super.present(viewControllerToPresent, animated: flag, completion: completion)
	}

	func navigationController(_ navigationController: UIKit.UINavigationController,
	                          willShow viewController: UIKit.UIViewController,
	                          animated: Bool)
	{
		guard let newController = viewController as? EnhancedViewController else { return }
		(viewController as? UICollectionViewController)?.customBackButton()
		(viewController as? UIViewController)?.customBackButton()
		
		searchBar.textColor = Theme.colors[6]
		self.searchBar.reset(controller: viewController)
		
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
