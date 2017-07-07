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

	override func loadView()
	{
		super.loadView()
		isNavigationBarHidden = true
		delegate = self
		enableEdgeGesture()
	}

	func navigationController(_ navigationController: UIKit.UINavigationController,
	                          willShow viewController: UIKit.UIViewController,
	                          animated: Bool)
	{
		guard let newController = viewController as? EnhancedViewController else { return }

		if let placeholder = newController.searchPlaceHolder
		{
			searchBar.textColor = Theme.colors[6]

			if (searchBar.superview == nil)
			{
				view.addSubview(searchBar)
				searchBar.isHidden = true
				searchBar.translatesAutoresizingMaskIntoConstraints = false
				searchBar.heightAnchor.constraint(equalToConstant: Constants.searchBarHeight).isActive = true
				searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.edgeMargin).isActive = true
				searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.edgeMargin).isActive = true
				searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.edgeMargin + Constants.statusBarHeight).isActive = true
			}
			searchBar.isHidden = false
			let string = NSAttributedString(string: placeholder,
			                                attributes: [NSAttributedStringKey.foregroundColor: Theme.colors[6], NSAttributedStringKey.font: Theme.SearchBarTextFont])
			self.searchBar.attributedPlaceholder = string
		}

		if let items = viewController.navigationItem.leftBarButtonItems { searchBar.leftView = buttonFromBarButtonItem(item: items[0]) } else { searchBar.leftView = UIView() }
		if let items = viewController.navigationItem.rightBarButtonItems { searchBar.rightView = buttonFromBarButtonItem(item: items[0]) } else { searchBar.rightView = UIView() }

		UIView.animate(withDuration: Constants.defaultTransitionDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
			{
				if (newController.searchPlaceHolder == nil ) { self.searchBar.alpha = 0 } else { self.searchBar.alpha = 1 }
				self.view.backgroundColor = newController.backgroundTintColor
		}, completion:
			{ (_) in
				if newController.searchPlaceHolder == nil { self.searchBar.isHidden = true } else { self.searchBar.isHidden = false }
		})
	}

	func buttonFromBarButtonItem(item: UIBarButtonItem) -> UIButton
	{
		let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: item.image!.size.width + 15, height: item.image!.size.height - 1)))
		button.tintColor = Theme.colors[5]
		button.setImage(item.image!, for: .normal)
		button.addTarget(item.target!, action: item.action!, for: .touchUpInside)
		return button
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
		return nil
	}
}
