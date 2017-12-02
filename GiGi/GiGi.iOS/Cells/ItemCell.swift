//
//  ItemCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/11/2017.
//

import UIKit

class ItemCell: Cell
{
	enum ItemType
	{
		case `default`
		case folder
		case secretFolder
	}
	
	var slideTransition: SlideTransition
	{
		let delegate = UIApplication.shared.delegate as? AppDelegate
		let navController = delegate?.window?.rootViewController as? UINavigationController
		return navController!.slideTransition
	}
	
	var itemType: ItemType = .default
	{
		didSet
		{
			switch itemType
			{
			case .default:
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Document-Uncheck"), for: .normal)
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Document-Checked"), for: .selected)
				break
			case .folder:
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Folder-Uncheck"), for: .normal)
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Folder-Checked"), for: .selected)
				break
			case .secretFolder:
				taskButton.setImage(#imageLiteral(resourceName: "Todo-Folder-Lock"), for: .normal)
				break
			}
		}
	}
	
	var taskButton = UIButton()
	var snapshot: UIView?
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		let pan = UIPanGestureRecognizer(target: self, action: #selector(itemCellDidPanned(gesture:)))
		pan.maximumNumberOfTouches = 1
		pan.minimumNumberOfTouches = 1
		pan.delegate = self
		addGestureRecognizer(pan)
		
		leftView = taskButton
		
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "Accessory-Action"), for: .normal)
		button.addTarget(self, action: #selector(didTappedAccessoryButton), for: .touchUpInside)
		rightView = button
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse()
	{
		// 忽略原来的 Cell 会删掉 LeftView 和 RightView
		return
	}
}

extension ItemCell: UIGestureRecognizerDelegate
{
	@objc func didTappedAccessoryButton()
	{
		Sound.tapLight.play()
		let navController = (UIApplication.shared.keyWindow?.rootViewController as! UINavigationController)
		let newController = (navController.visibleViewController as! ItemActionDelegate).itemActionController(forCell: self)
		navController.pushViewController(newController, animated: true)
	}
	
	@objc func itemCellDidPanned(gesture: UIPanGestureRecognizer)
	{
		let x = gesture.translation(in: self).x
		let ratio = x / self.superview!.bounds.width
		
		func startPan()
		{
			snapshot = contentView.resizableSnapshotView(from: contentView.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)!
			self.addSubview(snapshot!)
			contentView.isHidden = true
		}
		
		func changePan()
		{
			if slideTransition.isStarted
			{
				slideTransition.updateInteractiveTransition(percent: x / self.superview!.bounds.width)
				slideTransition.scrollToOffest(cellMaxY: self.frame.minY, gestureY: gesture.translation(in: self).y, previousY: 0)
			}
			else
			{
				if x <= 0 { return }
				if x >= Constants.slideMinmalCommitWidth
				{
					Sound.slideStarted.play()
					slideTransition.startTransition(cell: self)
				}
				else
				{
					var progess = Float(x / Constants.slideMinmalCommitWidth) - 0.2
					if progess < 0 { progess = 0 }
					self.snapshot?.transform = CGAffineTransform(translationX: x, y: 0)
				}
			}
		}
		
		func endPan()
		{
			if slideTransition.isStarted
			{
				self.snapshot?.removeFromSuperview()
				self.contentView.isHidden = false
				slideTransition.completeTransition()
			}
			else
			{
				Sound.slideCancel.play()
				UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations:
				{
					self.snapshot?.transform = CGAffineTransform.identity
				}, completion: { (_) in
					self.contentView.isHidden = false
					self.snapshot?.removeFromSuperview()
					self.slideTransition.cancelTransition()
				})
			}
		}
		
		switch gesture.state
		{
		case .began: startPan(); break
		case .changed: changePan(); break
		case .ended: endPan(); break
		default: break
		}
	}
	
	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
	{
		if let gesture = gestureRecognizer as? UIPanGestureRecognizer
		{
			let translation = gesture.translation(in: self.superview!)
			if (fabs(translation.x) / fabs(translation.y) <= 1) { return false }
			return true
		}
		return false
	}
}
