//
//  ItemListViewController+AddButton.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

extension ItemListViewController
{
	func didEnd(dragableButton: DragableButton, toPoint: CGPoint)
	{
		if let indexPath = newInsertIndexPath
		{
			newInsertIndexPath = nil
			let viewController = ItemCreatorViewController(item: item, index: indexPath.row)
			navigationController?.pushViewController(viewController, animated: true)
		}
	}
	
	func didTapped(dragableButton: DragableButton)
	{
		let creatorViewController = ItemCreatorViewController(item:item)
		self.navigationController?.pushViewController(creatorViewController, animated: true)
	}
	
	func didPanned(dragableButton: DragableButton, toPoint: CGPoint) -> CGFloat
	{
		if let indexPath = collectionView?.indexPathForItem(at: toPoint)
		{
			if let oldIndexPath = newInsertIndexPath
			{
				if oldIndexPath.row != indexPath.row && indexPath.row <= item.children.count
				{
					newInsertIndexPath = indexPath
					collectionView?.moveItem(at: oldIndexPath, to: indexPath)
				}
			} else if indexPath.row <= item.children.count
			{
				newInsertIndexPath = indexPath
				collectionView?.insertItems(at: [indexPath])
			}
			return 0
		} else
		{
			if let insertedIndexPath = newInsertIndexPath
			{
				newInsertIndexPath = nil
				collectionView?.deleteItems(at: [insertedIndexPath])
			}
			return 1
		}
	}
}

