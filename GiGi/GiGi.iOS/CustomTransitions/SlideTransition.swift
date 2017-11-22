//
//  SlideTransition.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

class SlideTransition: NSObject, UIViewControllerInteractiveTransitioning, UICollectionViewDelegate
{
	let navigationController	: UINavigationController
	var targetViewController  : UICollectionViewController?
	var targetVCSnapshot      : UIView?

	var itemCell            	: ItemCell!
	var itemCellSnapshot			: UIView!
	var transitionContext			: UIViewControllerContextTransitioning?
	var isStarted             : Bool = false
	var isActive              : Bool = false

	lazy var actionListViewController : ActionListViewController =
	{
		let controller = ActionListViewController()
		controller.delegate = self
		return controller
	}()

	init(navigationController: UINavigationController)
	{
		self.navigationController = navigationController
	}
}

// MARK: Slide Transition for Pan Gesture in ItemCell

extension SlideTransition
{
	func itemCellDidPanned(gesture: UIPanGestureRecognizer)
	{
		let X = gesture.translation(in: itemCell).x
		let ratio = X / UIScreen.main.bounds.width
		switch gesture.state
		{
		case .began:
			let snapshotFrame = CGRect(x: 0,y: 0,width: UIScreen.main.bounds.width,height: itemCell.frame.height - 1)
			itemCellSnapshot = itemCell.resizableSnapshotView(from: snapshotFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
			itemCell.addSubview(itemCellSnapshot)
			itemCell.contentView.isHidden = true
		case .changed:
			if X >= 0
			{
				if X <= Constants.slideMinmalCommitWidth
				{
					var progress = Float(X / Constants.slideMinmalCommitWidth) - 0.2
					if progress < 0 { progress = 0 }
					itemCellSnapshot?.transform = CGAffineTransform(translationX: X, y: 0)
				} else
				{
					if isStarted == false
					{
						isStarted = true
						navigationController.pushViewController(actionListViewController, animated: true)
					} else
					{
						if targetVCSnapshot == nil { targetVCSnapshot = targetViewController?.view.snapshotView(afterScreenUpdates: false) } else
						{
							actionListViewController.scrollToOffest(cellMaxY: itemCell.frame.minY,
							                                        gestureY: gesture.translation(in: itemCell).y,
							                                        previousY: targetViewController!.collectionView!.contentOffset.y)
							updateInteractiveTransition(percent: ratio)
						}
					}
				}
			}
		case .ended:
			if let indexPaths = actionListViewController.collectionView?.indexPathsForSelectedItems
			{
				if (indexPaths.count != 0 && isActive == true) { finishQuickSlideTransition(indexPath: indexPaths[0]) } else if isActive == false { cancelSlideTransition() } else { finishSlideTransition() }
			}
		default: break
		}
	}

	func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning)
	{
		self.transitionContext = transitionContext
		targetViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as? UICollectionViewController
		actionListViewController.actions = itemCell.actions!
		actionListViewController.navigationItem.rightBarButtonItem = nil
	}

	func updateInteractiveTransition(percent:CGFloat)
	{
		if isActive == false
		{
			isActive = true
			actionListViewController.view.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
			targetViewController?.view.isHidden = true
			transitionContext?.containerView.addSubview(actionListViewController.view)
			transitionContext?.containerView.addSubview(targetVCSnapshot!)
			targetVCSnapshot?.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
				{
					self.actionListViewController.view.transform = CGAffineTransform.identity
			}, completion: nil)
		}
		transitionContext?.updateInteractiveTransition(percent)
	}

	func finishQuickSlideTransition(indexPath: IndexPath)
	{
		itemCellSnapshot.removeFromSuperview()
		itemCell.contentView.isHidden = false
		targetVCSnapshot?.removeFromSuperview()
		self.navigationController.searchBar.isHidden = false

		let cell = actionListViewController.collectionView?.cellForItem(at: indexPath) as! Cell
		cell.isHighlighted = false
		actionListViewController.collectionView?.deselectItem(at: indexPath, animated: false)
		actionListViewController.collectionView?.isScrollEnabled = false
		targetViewController?.view.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
		targetViewController?.view.isHidden = false
		itemCell.delegate?.itemCell?(itemCell, didTriggerAction: indexPath.row)
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
		{
			self.navigationController.searchBar.alpha = 1
			self.targetViewController?.view.transform = CGAffineTransform.identity
			self.actionListViewController.view.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
		}, completion: { (_) -> Void in
			self.actionListViewController.view.transform = CGAffineTransform.identity
			self.transitionContext?.cancelInteractiveTransition()
			self.transitionContext?.completeTransition(false)
			self.reset()
			self.actionListViewController.collectionView?.isScrollEnabled = true
		})
	}

	func finishSlideTransition()
	{
		UIView.animate(withDuration: Constants.defaultTransitionDuration / 2,
		               delay: 0,
		               usingSpringWithDamping: 0.8,
		               initialSpringVelocity: 1,
		               options: UIViewAnimationOptions.curveEaseOut,
		               animations:
		{
			if self.actionListViewController.collectionView!.contentOffset.y < 0
			{
				self.actionListViewController.collectionView!.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
			}
		}, completion: { (_) -> Void in
			self.targetViewController?.view.removeFromSuperview()
			self.transitionContext?.finishInteractiveTransition()
			self.transitionContext?.completeTransition(true)
			self.reset()
		})
	}

	func cancelSlideTransition()
	{
		//    if isStarted == true { navigationController.topBar.popNavigationItemAnimated(false) }
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.itemCellSnapshot?.transform = CGAffineTransform.identity
		}, completion: { (_) -> Void in
			self.transitionContext?.cancelInteractiveTransition()
			self.transitionContext?.completeTransition(false)
			self.reset()
		})
	}

	func reset()
	{
		isStarted = false
		isActive = false
		targetVCSnapshot?.removeFromSuperview()
		itemCellSnapshot.removeFromSuperview()
		targetViewController?.view.isHidden = false
		itemCell.contentView.isHidden = false
		actionListViewController.quickMode = false
		actionListViewController.view.transform = CGAffineTransform.identity
		actionListViewController.currentActionIndex = -1
		itemCellSnapshot = nil
		targetVCSnapshot = nil
		transitionContext = nil
	}
}

extension SlideTransition: ActionListViewControllerDelegate
{
	func actionListView(_ actionListView: ActionListViewController, didSelectAction actionIndex: Int)
	{
		itemCell.delegate?.itemCell?(itemCell, didTriggerAction: actionIndex)
		self.navigationController.popViewController(animated: true)
	}
}

// MARK: Slide Transition for Tapping Accessory View on ItemCell

extension SlideTransition
{
	func itemCellDidTappedAccessoryView(cell: ItemCell)
	{
		itemCell = cell
		isStarted = true
		isActive = true
		navigationController.pushViewController(actionListViewController, animated: true)
		Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(startMove), userInfo: nil, repeats: false)
	}

	@objc func startMove()
	{
		targetVCSnapshot = targetViewController!.view.snapshotView(afterScreenUpdates: false)
		targetViewController?.view.isHidden = true
		actionListViewController.view.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
		transitionContext?.containerView.addSubview(targetVCSnapshot!)
		transitionContext?.containerView.addSubview(actionListViewController.view)
		transitionContext?.updateInteractiveTransition(1)

		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations:
		{
			self.targetVCSnapshot?.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
			self.actionListViewController.view.transform = CGAffineTransform.identity
		}, completion: { (_) -> Void in
			self.targetViewController?.view.isHidden = false
			self.transitionContext?.finishInteractiveTransition()
			self.transitionContext?.completeTransition(true)
			self.isStarted = false
			self.isActive = false
			self.targetVCSnapshot?.removeFromSuperview()
			self.targetVCSnapshot = nil
		})
	}
}
