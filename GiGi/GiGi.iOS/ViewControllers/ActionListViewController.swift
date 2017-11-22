//
//  ActionListViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

public enum ActionType
{
	case reschedule
	case move
	case rename
	case convert
	case delete
	case cancel

	var icon: UIImage?
	{
		switch self
		{
		case .reschedule: return #imageLiteral(resourceName: "List-Brief")
		case .move: return #imageLiteral(resourceName: "List-Move")
		case .rename: return #imageLiteral(resourceName: "List-Rename")
		case .convert: return #imageLiteral(resourceName: "List-Convert")
		case .delete: return #imageLiteral(resourceName: "List-Delete")
		case .cancel: return nil
		}
	}

	var title: String
	{
		switch self
		{
		case .reschedule: return ".list.actions.reschedule".localized
		case .rename: return ".list.actions.rename".localized
		case .move: return ".list.actions.move".localized
		case .convert: return ".list.actions.convert".localized
		case .delete: return ".list.actions.delete".localized
		case .cancel: return ".list.actions.cancel".localized
		}
	}
}

protocol ActionListViewControllerDelegate: NSObjectProtocol
{
	func actionListView(_ actionListView: ActionListViewController, didSelectAction actionIndex: Int)
}

class ActionListViewController: UICollectionViewController
{
	override var pushTransition : TransitionType { return TransitionType.right }
	override var popTransition : TransitionType { return TransitionType.left }
	var actions : [ActionType] = [] { didSet { collectionView?.reloadData() } }

	var quickMode: Bool = false
	var currentActionIndex: Int = -1
	weak var delegate: ActionListViewControllerDelegate?

	override func loadView()
	{
		super.loadView()
		self.clearsSelectionOnViewWillAppear = true
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}

	override func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		if currentActionIndex >= 0
		{
			let cell = self.collectionView?.cellForItem(at: IndexPath(row: currentActionIndex, section: 0)) as? Cell
			cell?.isHighlighted(highlight: false)
			currentActionIndex = -1
		}
	}
}

extension ActionListViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return actions.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		if let icon = actions[indexPath.row].icon { cell.icon = icon }
		cell.titleLabel.text = actions[indexPath.row].title.localized
		cell.tintColor = Theme.colors[7]
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		if (quickMode == false) { delegate?.actionListView(self, didSelectAction: indexPath.row) }
	}
}

extension ActionListViewController
{
	func scrollToOffest(cellMaxY: CGFloat, gestureY: CGFloat, previousY: CGFloat)
	{
		let offestY = (UIScreen.main.bounds.height - Defaults.listHeight.float - cellMaxY) - (Constants.cellHeight / 2) + previousY - (gestureY * 3)
		let offest = CGPoint(x: 0, y: offestY)
		collectionView?.contentOffset = offest
		if !quickMode && gestureY < -10 { quickMode = true } else if (quickMode)
		{
			let newIndex = Int((-gestureY - 10) / 22)
			if newIndex != currentActionIndex && newIndex >= 0 && newIndex < actions.count
			{
				if currentActionIndex >= 0
				{
					let previousIndex = IndexPath(row: currentActionIndex, section: 0)
					let previousCell = collectionView?.cellForItem(at: previousIndex) as! Cell
					collectionView?.deselectItem(at: previousIndex, animated: false)
					previousCell.isHighlighted(highlight: false, animateDuration: 0.2)
				}
				let currentIndex = IndexPath(row: newIndex, section: 0)
				let currentCell = collectionView?.cellForItem(at: currentIndex) as! Cell
				collectionView?.selectItem(at: currentIndex, animated: false, scrollPosition: [])
				currentCell.isHighlighted(highlight: true, animateDuration: 0.2)
				currentActionIndex = newIndex
			}
		}
	}
}
