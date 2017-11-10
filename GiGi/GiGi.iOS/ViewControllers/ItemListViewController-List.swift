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
		return item.children.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
		
		var itemIndex: Int?
		if let placeholderIndexPath = newInsertIndexPath
		{
			if (indexPath.row < placeholderIndexPath.row) { itemIndex = indexPath.row } else { itemIndex = indexPath.row + 1 }
		} else if (indexPath.row < self.item.children.count) { itemIndex = indexPath.row }
		
		if itemIndex != nil
		{
			let childItem = item.children[indexPath.row]
			if let icon = childItem.itemType.icon, let image = UIImage(named: icon) { cell.icon = image }
			cell.actions = [.reschedule, .move, .convert, .rename, .delete]
			cell.titleLabel.text = childItem.title
			cell.tintColor = Theme.colors[6]
			cell.delegate = self
		}
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
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
	}
}
