//
//  UIViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

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
	weak var searchDelegate: SearchBarDelegate? { get }
	var isSlideActionModeEnable: Bool { get set }
	var showCloseButton: Bool { get }
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
		if showCloseButton
		{
			let item = UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Close"), style: .plain, target: self, action: #selector(backButtonTapped))
			item.title = ".universal.cancel".localized
			self.navigationItem.rightBarButtonItem = item
		}
		else if let navController = navigationController, navController.viewControllers.count > 1 && navigationItem.leftBarButtonItem == nil
		{
			let item = UIBarButtonItem(image: UIImage(named: "Navigation-Back")!, style: .plain, target: self, action: #selector(backButtonTapped))
			item.title = navController.viewControllers[navController.viewControllers.count - 2].title
			self.navigationItem.leftBarButtonItem = item
		}
	}
	
	func alert(title: String, message: String)
	{
		Sound.alert.play()
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
	}
}

extension UIKit.UIViewController
{
	@objc func backButtonTapped()
	{
		DispatchQueue.main.async
		{
			Sound.tapNavButton.play()
			self.navigationController?.popViewController(animated: true)
		}
	}
}

class UIViewController: UIKit.UIViewController, EnhancedViewController
{
	var isSlideActionModeEnable: Bool = false
	
	var showCloseButton: Bool { return false }
	var backgroundTintColor : UIColor { return Theme.colors[1] }
	var pushTransition : TransitionType { return TransitionType.default }
	var popTransition : TransitionType { return TransitionType.default }
	weak var searchDelegate: SearchBarDelegate? { return nil }

	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		if backgroundTintColor.isVisibleOnWhiteBackground == false { return UIStatusBarStyle.default }
		return UIStatusBarStyle.lightContent
	}
}
