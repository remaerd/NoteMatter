//
//  UIViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

internal enum TransitionType
{
	case `default`
	case left
	case right
	case bottom
	case syste
}

protocol EnhancedViewController
{
	var backgroundTintColor : UIColor { get }
	var pushTransition: TransitionType { get }
	var popTransition : TransitionType { get }
	var searchPlaceHolder : String? { get }
	weak var searchDelegate: SearchBarDelegate? { get }
}

extension EnhancedViewController where Self:UIKit.UIViewController
{
	func hideSearchBar(hidden: Bool)
	{
		if let navigationController = self.navigationController as? UINavigationController
		{
			if (hidden == false && navigationController.searchBar.isHidden) { navigationController.searchBar.isHidden = hidden }
			UIView.animate(withDuration: Constants.defaultTransitionDuration / 2, animations:
			{
				if hidden
				{
					navigationController.searchBar.transform = CGAffineTransform.init(translationX: 0, y: -(Constants.statusBarHeight+Constants.searchBarHeight+Constants.edgeMargin * 2))
				} else
				{
					navigationController.searchBar.transform = CGAffineTransform.identity
				}
			}, completion:
			{ (_) in
				if (hidden) { navigationController.searchBar.isHidden = hidden }
			})
		}
	}

	func customBackButton()
	{
		if let navController = navigationController, navController.viewControllers.count > 1
		{
			let item = UIBarButtonItem(image: UIImage(named: "Navigation-Back")!, style: .plain, target: self, action: #selector(backButtonTapped))
			self.navigationItem.leftBarButtonItems = [item]
		}
	}
}

extension UIKit.UIViewController
{
	@objc func backButtonTapped()
	{
		DispatchQueue.main.async
		{
			self.navigationController?.popViewController(animated: true)
		}
	}
}

class UIViewController: UIKit.UIViewController, EnhancedViewController
{
	var backgroundTintColor : UIColor { return Theme.colors[1] }
	var pushTransition : TransitionType { return TransitionType.default }
	var popTransition : TransitionType { return TransitionType.default }
	var searchPlaceHolder : String? { return nil }
	weak var searchDelegate: SearchBarDelegate? { return nil }

	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		if backgroundTintColor.isVisibleOnWhiteBackground == false { return UIStatusBarStyle.default }
		return UIStatusBarStyle.lightContent
	}

	override func loadView()
	{
		super.loadView()
		customBackButton()
	}
}
