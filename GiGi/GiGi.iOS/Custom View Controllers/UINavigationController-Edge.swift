//
//  UINavigationController-Edge.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 06/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

extension UINavigationController : UIGestureRecognizerDelegate
{
	func enableEdgeGesture()
	{
		leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action:#selector(panningEdge(gesture:)))
		leftEdgeGesture!.edges = UIRectEdge.left
		leftEdgeGesture!.delegate = self
		
		rightEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panningEdge(gesture:)))
		rightEdgeGesture!.edges = UIRectEdge.right
		rightEdgeGesture!.delegate = self
		
		view.addGestureRecognizer(leftEdgeGesture!)
		view.addGestureRecognizer(rightEdgeGesture!)
	}
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
	{
		let edge = gestureRecognizer as! UIScreenEdgePanGestureRecognizer
		if edge.edges == .left && ((visibleViewController?.navigationItem.leftBarButtonItems) != nil) { return true } else if edge.edges == .right && ((visibleViewController?.navigationItem.leftBarButtonItems) != nil) { return true }
		return false
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
	{
		return true
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
	{
		return true
	}
	
	@objc func panningEdge(gesture: UIScreenEdgePanGestureRecognizer)
	{
		var pointX = gesture.translation(in: view!).x
		
		func beginPanning()
		{
			var items : [UIBarButtonItem]?
			var images = [UIImage]()
			
			if gesture.edges == .left
			{
				items = visibleViewController?.navigationItem.leftBarButtonItems
				if items != nil
				{
					currentEdgeIndicator = leftEdgeIndicator
					currentEdgeIndicator!.frame = CGRect(x: -UIScreen.main.bounds.width, y: CGFloat(gesture.location(in: view).y - (64 / 2)), width: UIScreen.main.bounds.width, height: Constants.cellHeight)
				}
			} else if gesture.edges == .right
			{
				items = visibleViewController?.navigationItem.rightBarButtonItems
				if items != nil
				{
					currentEdgeIndicator = rightEdgeIndicator
					currentEdgeIndicator!.frame = CGRect(x: UIScreen.main.bounds.width, y: CGFloat(gesture.location(in: view).y - (64 / 2)), width: UIScreen.main.bounds.width, height: Constants.cellHeight)
				}
			}
			
			if items != nil { for item in items! { if let image = item.image { images.append(image) } } }
			
			if currentEdgeIndicator != nil
			{
				if images.isEmpty { currentEdgeIndicator?.images = nil } else { currentEdgeIndicator?.images = images }
				view.addSubview(currentEdgeIndicator!)
			}
		}
		
		func panning()
		{
			guard let indicator = currentEdgeIndicator else { return }
			UIView.animate(withDuration: 0.15, animations:
				{
					var currentState = 0
					if (pointX < Constants.slideMinmalCommitWidth && indicator.cornerType == .left) || (pointX > -Constants.slideMinmalCommitWidth && indicator.cornerType == .right)
					{
						indicator.transform = CGAffineTransform.init(translationX: pointX, y: 0)
						
						if indicator.panState != 0
						{
							// SoundEffect.play(.PanCancel)
							indicator.panState = 0
							indicator.alpha = 0.5
						}
					} else
					{
						switch indicator.cornerType
						{
						case .left:
							currentState = Int((pointX - Constants.slideMinmalCommitWidth) / 64) + 1
							if pointX > indicator.maxiumumWidth + Constants.slideMinmalCommitWidth { pointX = indicator.maxiumumWidth + Constants.slideMinmalCommitWidth }
							indicator.transform = CGAffineTransform.init(translationX: pointX, y: 0)
							break
						case .right:
							currentState = Int((fabs(pointX) + Constants.slideMinmalCommitWidth) / 64) - 1
							if fabs(pointX) > indicator.maxiumumWidth + Constants.slideMinmalCommitWidth { pointX = -indicator.maxiumumWidth - Constants.slideMinmalCommitWidth }
							indicator.transform = CGAffineTransform.init(translationX: pointX, y: 0)
						}
						
						if currentState > (indicator.images?.count)! { currentState = indicator.images!.count }
						if currentState != indicator.panState
						{
							// SoundEffect.play(.PanCommit)
							indicator.panState = currentState
							indicator.alpha = 1
						}
					}
			})
		}
		
		func endPanning()
		{
			guard let indicator = currentEdgeIndicator else { return }
			var triggered = false
			if indicator.cornerType == .left && pointX >= Constants.slideMinmalCommitWidth { triggered = true } else if indicator.cornerType == .right && pointX <= -Constants.slideMinmalCommitWidth { triggered = true }
			
			if triggered == true
			{
				// SoundEffect.play(.PanSuccess)
				let barButton : UIBarButtonItem
				if currentEdgeIndicator?.cornerType == .left { barButton = visibleViewController!.navigationItem.leftBarButtonItems![indicator.panState - 1] as UIBarButtonItem } else { barButton = visibleViewController!.navigationItem.rightBarButtonItems![indicator.panState - 1] as UIBarButtonItem }
				barButton.target?.performSelector(inBackground: barButton.action!, with: ["index":indicator.panState - 1])
			}
			
			UIView.animate(withDuration: 0.4, animations:
				{
					indicator.transform = CGAffineTransform.identity
					indicator.panState = 0
			}, completion:
				{
					(_) in
					indicator.removeFromSuperview()
			})
		}
		
		switch gesture.state
		{
		case .began: beginPanning()
		case .changed: panning()
		case .ended: endPanning()
		default: break
		}
	}
}

class EdgeIndicator : UIView
{
	enum CornerType
	{
		case left
		case right
	}
	
	let blurEffect  : UIBlurEffect
	let blurView    : UIVisualEffectView
	let cornerType  : CornerType
	
	var panState : Int = 0
	{
		didSet {
			if self.panState > 0 {
				self.imageView.image = self.images?[panState - 1].withRenderingMode(UIImageRenderingMode.alwaysTemplate)
			}
		}
	}
	
	var maxiumumWidth : CGFloat
	{
		return CGFloat(self.images!.count * 64)
	}
	
	lazy var imageView : UIImageView =
		{
			let view = UIImageView(frame: CGRect.zero)
			view.tintColor = Theme.colors[1]
			view.contentMode = UIViewContentMode.center
			if self.cornerType == .left { view.frame = CGRect(x:UIScreen.main.bounds.width - 44, y:0, width:44, height:44) } else if self.cornerType == .right { view.frame = CGRect(x:0, y:0, width:44, height:44) }
			self.addSubview(view)
			return view
	}()
	
	var images : [UIImage]?
	{
		willSet(newValue) {
			if newValue != nil {
				self.imageView.image = newValue?[0].withRenderingMode(UIImageRenderingMode.alwaysTemplate)
				self.alpha = 0.75
			}
		}
	}
	
	init(frame: CGRect, cornerType: CornerType)
	{
		if Theme.isMorning { self.blurEffect = UIBlurEffect(style: .dark) } else { self.blurEffect = UIBlurEffect(style: .extraLight) }
		
		self.blurView = UIVisualEffectView(effect: self.blurEffect)
		self.cornerType = cornerType
		super.init(frame: frame)
		self.blurView.frame = self.bounds
		self.blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		self.addSubview(self.blurView)
		self.layer.cornerRadius = Constants.defaultCornerRadius
		self.blurView.layer.cornerRadius = Constants.defaultCornerRadius
		self.layer.masksToBounds = true
	}
	
	required init(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

