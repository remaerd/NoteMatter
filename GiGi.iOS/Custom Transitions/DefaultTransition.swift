//
//  DefaultTransition.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 07/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

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
