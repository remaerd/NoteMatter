//
//  ItemListViewController-List.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 13/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

extension ItemListViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		var result = item.children.count
		if (self.item.identifier == Item.InternalItem.rootFolder.identifier) { result += 1 }
		if (newInsertIndexPath != nil) { result += 1 }
		return result
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
		
		if let placeholderIndexPath = newInsertIndexPath, placeholderIndexPath.row == indexPath.row
		{
			cell.icon = #imageLiteral(resourceName: "List-Plus")
			cell.titleLabel.text = ".list.insert".localized
			cell.tintColor = Theme.colors[0]
			cell.backgroundColor = Theme.colors[6]
		} else
		{
			var itemIndex: Int?
			if let placeholderIndexPath = newInsertIndexPath
			{
				if (indexPath.row < placeholderIndexPath.row) { itemIndex = indexPath.row } else { itemIndex = indexPath.row + 1 }
			} else if (indexPath.row < self.item.children.count) { itemIndex = indexPath.row }
			
			if itemIndex != nil
			{
				let childItem = item.children[indexPath.row]
				if let icon = childItem.itemType.icon, let image = UIImage(named: icon) { cell.icon = image }
				cell.actions = [ItemAction.reschedule, ItemAction.share, ItemAction.move, ItemAction.rename, ItemAction.delete]
				cell.titleLabel.text = childItem.title
				cell.tintColor = Theme.colors[6]
				cell.delegate = self
			} else
			{
				cell.titleLabel.text = ".item.preferences".localized
				cell.icon = UIImage(named:"List-Preferences")
				cell.tintColor = Theme.colors[6]
			}
		}
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		if (indexPath.row < item.children.count)
		{
			let selectedItem = self.item.children[indexPath.row]
			switch selectedItem.itemType.identifier
			{
			case LocalItemType.InternalItemType.folder.identifier:
				self.navigationController?.pushViewController(ItemListViewController(item: selectedItem), animated: true)
				break
			default:
				self.navigationController?.pushViewController(ItemEditorViewController(item: selectedItem), animated: true)
				break
			}
		} else if (self.item.identifier == Item.InternalItem.rootFolder.identifier)
		{
			let viewController = PreferencesViewController()
			navigationController?.pushViewController(viewController, animated: true)
		}
	}
}
