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
	var leftEdge: UIScreenEdgePanGestureRecognizer!
	var rightEdge: UIScreenEdgePanGestureRecognizer!

	lazy var searchBar: SearchBar = SearchBar()

	override func loadView()
	{
		super.loadView()

		isNavigationBarHidden = true
		delegate = self

		leftEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panningEdge(gesture:)))
		leftEdge.isEnabled = false

		rightEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panningEdge(gesture:)))
		rightEdge.isEnabled = false

		view.addGestureRecognizer(leftEdge)
		view.addGestureRecognizer(rightEdge)
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

		UIView.animate(withDuration: Constants.defaultTransitionDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
			{
				if (newController.searchPlaceHolder == nil ) { self.searchBar.alpha = 0 } else { self.searchBar.alpha = 1 }
				self.view.backgroundColor = newController.backgroundTintColor
		}, completion:
			{ (_) in
				if newController.searchPlaceHolder == nil { self.searchBar.isHidden = true } else { self.searchBar.isHidden = false }
		})

		if (self.viewControllers.count <= 1) { searchBar.leftView = UIView() } else
		{
			let image = UIImage(named: "Navigation-Back")!
			let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: image.size.width + 15, height: image.size.height - 1)))
			button.tintColor = Theme.colors[5]
			button.setImage(image, for: .normal)
			button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
			searchBar.leftView = button
		}
	}

	func navigationController(_ navigationController: UIKit.UINavigationController,
	                          animationControllerFor operation: UINavigationControllerOperation,
	                          from fromVC: UIKit.UIViewController,
	                          to toVC: UIKit.UIViewController) -> UIViewControllerAnimatedTransitioning?
	{
		guard let fromVC = fromVC as? EnhancedViewController else { return nil }
		guard let toVC = toVC as? EnhancedViewController else { return nil }

		switch operation
		{
		case .push:
			switch toVC.pushTransition
			{
			case .default: return DefaultTransition(direction: .left)
			case .left: return DefaultTransition(direction: .left)
			case .right: return DefaultTransition(direction: .right)
			case .bottom: return DefaultTransition(direction: .bottom)
			default: return nil
			}
		case .pop:
			switch fromVC.popTransition
			{
			case .default: return DefaultTransition(direction: .right)
			case .left: return DefaultTransition(direction: .left)
			case .right: return DefaultTransition(direction: .right)
			case .bottom: return DefaultTransition(direction: .bottom)
			default: return nil
			}
		default: return nil
		}
	}

	func navigationController(_ navigationController: UIKit.UINavigationController,
	                          interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
	{
		return nil
	}

	@objc func backButtonTapped()
	{
		popViewController(animated: true)
	}
}

extension UINavigationController
{
	@objc func panningEdge(gesture: UIScreenEdgePanGestureRecognizer)
	{

	}
}

class DefaultTransition: NSObject, UIViewControllerAnimatedTransitioning
{
	enum DirectionType
	{
		case left
		case right
		case bottom
	}

	let direction: DirectionType

	init(direction:DirectionType)
	{
		self.direction = direction
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
	{
		let fromVC = transitionContext.viewController(forKey: .from)!
		let toVC = transitionContext.viewController(forKey: .to)!
		let fromView = fromVC.view.snapshotView(afterScreenUpdates: false)
		let toView = toVC.view.snapshotView(afterScreenUpdates: true)

		func finishTransition()
		{
			toView?.removeFromSuperview()
			fromView?.removeFromSuperview()
			transitionContext.containerView.addSubview(toVC.view)
			transitionContext.completeTransition(true)
		}

		transitionContext.containerView.addSubview(fromView!)
		transitionContext.containerView.addSubview(toView!)

		switch (direction)
		{
		case .left: toView?.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
		case .right: toView?.transform = CGAffineTransform.init(translationX: -UIScreen.main.bounds.width, y: 0)
		case .bottom: toView?.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height)
		}

		fromVC.view.removeFromSuperview()

		let duration = transitionDuration(using: transitionContext)
		if (direction == .bottom)
		{
			UIView.animate(withDuration: duration / 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
			{
				fromView?.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height)
			}, completion: nil)

			UIView.animate(withDuration: duration / 2, delay: duration / 2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
			{
				toView?.transform = CGAffineTransform.identity
			}, completion: { _ in finishTransition() })
		} else
		{
			UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations:
			{
				if (self.direction == .left)
				{
					toView?.transform = CGAffineTransform.identity
					fromView?.transform = CGAffineTransform.init(translationX: -UIScreen.main.bounds.width, y: 0)
				} else
				{
					toView?.transform = CGAffineTransform.identity
					fromView?.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
				}
			}, completion: { _ in finishTransition() })
		}
	}

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
	{
		return TimeInterval(Constants.defaultTransitionDuration)
	}
}
