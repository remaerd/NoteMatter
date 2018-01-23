//
//  SlideTransition.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 23/11/2017.
//

import UIKit

class SlideTransition: NSObject
{
	enum SlideDirection
	{
		case left
		case right
	}
	
	weak var navigationController: UINavigationController?
	var currentViewController: UICollectionViewController?
	var newViewController: UICollectionViewController?
	var slideDirection = SlideDirection.left
	var currentActionIndex: Int = -1
	var transitionContext: UIViewControllerContextTransitioning?
	var isStarted = false
	var isActive = false
	var isQuickMode = false
	var snapshot: UIView?
	
	init(navigationController: UINavigationController)
	{
		super.init()
		self.navigationController = navigationController
	}
}

extension SlideTransition
{
	func scrollToOffest(cellMaxY: CGFloat, gestureY: CGFloat, previousY: CGFloat)
	{
		guard let collectionView = newViewController?.collectionView else { return }
		let offestY = (UIScreen.main.bounds.height - Defaults.listHeight.float - cellMaxY) - (Constants.cellHeight / 2) + previousY - (gestureY * 3)
		let offest = CGPoint(x: 0, y: offestY)
		collectionView.contentOffset = offest
		if !isQuickMode && gestureY < -20
		{
			navigationController?.searchBar.placeholder = ".placeholder.slide-commit".localized
			isQuickMode = true
			
		} else if (isQuickMode)
		{
			let newIndex = Int((-gestureY - 20) / 22)
			if newIndex != currentActionIndex && newIndex >= 0 && newIndex < collectionView.numberOfItems(inSection: 0)
			{
				if currentActionIndex >= 0
				{
					let previousIndex = IndexPath(row: currentActionIndex, section: 0)
					let previousCell = newViewController?.collectionView?.cellForItem(at: previousIndex) as! Cell
					newViewController?.collectionView?.deselectItem(at: previousIndex, animated: false)
					previousCell.isHighlighted(highlight: false, animateDuration: 0.2)
				}
				Sound.slideSelected.play()
				let currentIndex = IndexPath(row: newIndex, section: 0)
				let currentCell = newViewController?.collectionView?.cellForItem(at: currentIndex) as! Cell
				collectionView.selectItem(at: currentIndex, animated: false, scrollPosition: [])
				currentCell.isHighlighted(highlight: true, animateDuration: 0.2)
				currentActionIndex = newIndex
			}
		}
	}
}

extension SlideTransition: UIViewControllerInteractiveTransitioning
{
	func startTransition(cell: ItemCell?)
	{
		isStarted = true
		let controller : UIKit.UIViewController
		if let cell = cell
		{
			slideDirection = .left
			controller = (navigationController?.visibleViewController as! ItemActionDelegate).itemActionController(forCell: cell)
		}
		else
		{
			slideDirection = .right
			controller = (navigationController?.visibleViewController as! EdgeActionDelegate).rightEdgeActionController()
		}
		navigationController?.pushViewController(controller, animated: true)
	}
	
	func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning)
	{
		self.transitionContext = transitionContext
		currentViewController = transitionContext.viewController(forKey: .from) as? UICollectionViewController
		newViewController = transitionContext.viewController(forKey: .to) as? UICollectionViewController
	}
	
	func updateInteractiveTransition(percent: CGFloat)
	{
		if isActive == false && currentViewController != nil
		{
			isActive = true
			snapshot = currentViewController!.view.snapshotView(afterScreenUpdates: false)
			currentViewController?.view.isHidden = true
			
			transitionContext?.containerView.addSubview(snapshot!)
			transitionContext?.containerView.addSubview(newViewController!.view)
			if slideDirection == .left
			{ newViewController?.view.transform = CGAffineTransform(translationX: -newViewController!.view.bounds.width, y: 0) }
			else { newViewController?.view.transform = CGAffineTransform(translationX: newViewController!.view.bounds.width, y: 0)}
			
			UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
			{
				if self.slideDirection == .left { self.snapshot?.transform = CGAffineTransform(translationX: self.newViewController!.view.bounds.width, y: 0) }
				else { self.snapshot?.transform = CGAffineTransform(translationX: -self.newViewController!.view.bounds.width, y: 0) }
				self.newViewController?.view.transform = CGAffineTransform.identity
			}, completion: {(finished) in
				self.snapshot?.removeFromSuperview()
			})
		}
		transitionContext?.updateInteractiveTransition(percent)
	}
}

extension SlideTransition
{
	func completeTransition()
	{
		guard let indexPaths = self.newViewController?.collectionView?.indexPathsForSelectedItems else { return }
		if indexPaths.count != 0 { self.finishTransitionWithQuickAction(indexPath: indexPaths[0]) }
		else { self.finishTransition() }
	}
	
	func finishTransitionWithQuickAction(indexPath: IndexPath)
	{
		isStarted = false
		
		self.newViewController?.isSlideActionModeEnable = true
		self.newViewController?.collectionView((self.newViewController?.collectionView!)!, didSelectItemAt: indexPath)
		self.newViewController?.isSlideActionModeEnable = false
		
		let cell = newViewController?.collectionView?.cellForItem(at: indexPath) as! Cell
		cell.isHighlighted = false
		
		if self.slideDirection == .left
		{ currentViewController?.view.transform = CGAffineTransform(translationX: currentViewController!.view.bounds.width, y: 0) }
		else { currentViewController?.view.transform = CGAffineTransform(translationX: -currentViewController!.view.bounds.width, y: 0) }
		
		currentViewController?.view.isHidden = false
		navigationController?.searchBar.reset(controller: currentViewController!)
		UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations:
		{
			self.navigationController?.searchBar.alpha = 1
			self.currentViewController?.view.transform = CGAffineTransform.identity
			if self.slideDirection == .left
			{ self.newViewController?.view.transform = CGAffineTransform(translationX: -self.newViewController!.view.bounds.width, y: 0) }
			else { self.newViewController?.view.transform = CGAffineTransform(translationX: self.newViewController!.view.bounds.width, y: 0) }
		}, completion: {(_) in
			
			self.newViewController?.view.transform = CGAffineTransform.identity
			self.transitionContext?.cancelInteractiveTransition()
			self.transitionContext?.completeTransition(false)
			self.reset()
		})
	}
	
	func finishTransition()
	{
		Sound.slideCancel.play()
		
		self.isStarted = false
		navigationController?.searchBar.reset(controller: newViewController!)
		UIView.animate(withDuration: Constants.defaultTransitionDuration / 2, animations:
		{
			self.newViewController?.collectionView?.setContentOffset(CGPoint.zero, animated: true)
		}, completion:
		{ (_) in
			self.currentViewController?.view.isHidden = false
			self.transitionContext?.finishInteractiveTransition()
			self.transitionContext?.completeTransition(true)
			self.reset()
		})
	}
	
	func cancelTransition()
	{
		self.transitionContext?.cancelInteractiveTransition()
		self.transitionContext?.completeTransition(false)
		self.reset()
	}
	
	func reset()
	{
		currentViewController = nil
		newViewController = nil
		currentActionIndex = -1
		isQuickMode = false
		isActive = false
		isStarted = false
		transitionContext = nil
	}
}
