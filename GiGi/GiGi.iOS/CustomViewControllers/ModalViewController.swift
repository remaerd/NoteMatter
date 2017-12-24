//
//  ModalViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 18/11/2017.
//

import UIKit

class ModalViewController: UIPresentationController
{
	lazy var dimmingView = UIView()
	
	@objc func dismiss()
	{
		self.presentedViewController.dismiss(animated: true, completion: nil)
	}
	
	override func presentationTransitionWillBegin()
	{
		Sound.keyboardUp.play()
		super.presentationTransitionWillBegin()
		self.dimmingView.backgroundColor = Theme.colors[7]
		self.presentedViewController.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
		self.dimmingView.frame = self.containerView!.bounds
		self.dimmingView.alpha = 0
		self.containerView?.insertSubview(self.dimmingView, belowSubview: self.presentedView!)
		presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in self.dimmingView.alpha = 0.3 }, completion: nil)
	}
	
	override func dismissalTransitionWillBegin()
	{
		Sound.keyboardDown.play()
		super.dismissalTransitionWillBegin()
		presentedViewController.transitionCoordinator?.animate(alongsideTransition:
		{ (context) in
			self.dimmingView.alpha = 0
		}, completion: { (context) in
			self.dimmingView.removeFromSuperview()
		})
	}
	
	override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize
	{
		return parentSize
	}
	
	override func containerViewWillLayoutSubviews()
	{
		self.dimmingView.frame = containerView!.bounds
		presentedView?.frame = frameOfPresentedViewInContainerView
	}
	
	override var frameOfPresentedViewInContainerView: CGRect
	{
		return  self.presentedView!.bounds
	}
}
