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
		super.presentationTransitionWillBegin()
		self.dimmingView.backgroundColor = UIColor.black
		self.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
		self.dimmingView.frame = self.containerView!.bounds
		self.dimmingView.alpha = 0
		self.containerView?.insertSubview(self.dimmingView, belowSubview: self.presentedView!)
		
		let blurEffect = UIBlurEffect(style: .extraLight)
		let blurView = UIVisualEffectView(effect: blurEffect)
		blurView.frame = self.presentedView!.bounds
		presentedView?.insertSubview(blurView, at: 0)
		
		presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in self.dimmingView.alpha = 0.3 }, completion: nil)
	}
	
	override func dismissalTransitionWillBegin()
	{
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
		let height = Defaults.listHeight.float + Constants.edgeMargin * 2
		let y = UIScreen.main.bounds.height - Constants.edgeMargin - Defaults.listHeight.float
		return CGRect(x: 0, y: y, width: self.presentedView!.bounds.width, height: height)
	}
}
