//
//  SearchBar-Edge.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 24/11/2017.
//

import UIKit
import Cartography

extension SearchBar
{
	func didSetIndicator(cornerType: EdgeIndicator.CornerType)
	{
		var gesture: UIScreenEdgePanGestureRecognizer
		var indicator : EdgeIndicator?
		switch cornerType
		{
		case .left:
			indicator = leftEdgeIndicator
			gesture = leftEdgeGesture
			break
		case .right:
			indicator = rightEdgeIndicator
			gesture = rightEdgeGesture
			break
		}
		gesture.isEnabled = false
		if let indicator = indicator
		{
			indicator.isHidden = true
			gesture.isEnabled = true
			superview?.addSubview(indicator)
			
			constrain(indicator)
			{
				indicator in
				indicator.top == indicator.superview!.superview!.top + Constants.edgeMargin + Constants.statusBarHeight
				indicator.height == Constants.searchBarHeight
				indicator.leading == indicator.superview!.superview!.leading + Constants.edgeMargin
				indicator.trailing == indicator.superview!.superview!.trailing - Constants.edgeMargin
			}
		}
	}
	
	@objc func edgeDidPanned(gesture: UIScreenEdgePanGestureRecognizer)
	{
		let indicator: EdgeIndicator
		let minimumCommitWidth = self.bounds.width / 2  - Constants.edgePanMinimumWidth
		
		switch gesture.edges
		{
		case .left: indicator = leftEdgeIndicator!; break
		case .right:  indicator = rightEdgeIndicator!; break
		default: fatalError()
		}
		
		func beganPan()
		{
			indicator.isHidden = false
			indicator.alpha = 0
			UIView.animate(withDuration: 0.2)
			{
				indicator.alpha = 1
			}
		}
		
		func changedPan()
		{
			let x = gesture.translation(in: self).x
		
			if slideTransition.isStarted
			{
				slideTransition.updateInteractiveTransition(percent: x / self.superview!.bounds.width)
				slideTransition.scrollToOffest(cellMaxY: 0, gestureY: gesture.translation(in: self).y, previousY: -(gesture.location(in: self).y) - 22)
			}
			else
			{
				if fabs(x) > minimumCommitWidth
				{
					if indicator.more
					{
						self.slideTransition.startTransition(cell: nil)
						indicator.label.text = ".placeholder.slide".localized
					}
					if indicator.widthConstraint?.constant != self.bounds.width + minimumCommitWidth
					{
						Sound.slideStarted.play()
						UIView.animate(withDuration: 0.3, animations:
						{
							indicator.backgroundImage.tintColor = Theme.colors[5]
							indicator.label.textColor = Theme.colors[0]
							indicator.widthConstraint?.constant = self.bounds.width + minimumCommitWidth
							indicator.layoutIfNeeded()
						})
					}
				}
				else
				{
					if indicator.backgroundImage.tintColor != Theme.colors[3] { Sound.slideCancel.play() }
					UIView.animate(withDuration: 0.1, animations:
					{
						indicator.backgroundImage.tintColor = Theme.colors[3]
						indicator.label.textColor = Theme.colors[5]
						indicator.widthConstraint?.constant = Constants.edgePanMinimumWidth + (fabs(x) / 4)
						indicator.layoutIfNeeded()
					})
				}
			}
		}
		
		func endPan()
		{
			if slideTransition.isStarted { slideTransition.completeTransition() }
			else
			{
				let completed = fabs(gesture.translation(in: self).x) >= minimumCommitWidth
				if completed { Timer.init(timeInterval: 0, target: indicator.target!, selector: indicator.action!, userInfo: nil, repeats: false).fire() }
			}
			UIView.animate(withDuration: 0.2, animations:
			{
				indicator.alpha = 0
				let completed = fabs(gesture.translation(in: self).x) >= minimumCommitWidth
				if !completed
				{
					indicator.widthConstraint?.constant = Constants.edgePanMinimumWidth
					indicator.layoutIfNeeded()
				}
			}) { (_) in
				indicator.widthConstraint?.constant = Constants.edgePanMinimumWidth
				indicator.isHidden = true
			}
		}
		
		switch gesture.state
		{
		case .began: beganPan(); break
		case .changed: changedPan(); break
		case .ended: endPan(); break
		default: print(gesture.state == .cancelled); break
		}
	}
}
