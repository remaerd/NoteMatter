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
		return item.children!.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
		let childItem = item.children![indexPath.row]
		
		if (childItem as! Item).type.isFolder
		{
			cell.itemType = .folder
			cell.actions = [.rename, .move, .convert, .delete, .cancel]
		}
		else
		{
			cell.itemType = .default
			cell.actions = [.reschedule, .move, .convert, .delete, .cancel]
		}
		
		cell.titleLabel.text = (childItem as AnyObject).title.localized
		cell.tintColor = Theme.colors[6]
		cell.delegate = self
		
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		let selectedItem = self.item.children![indexPath.row]
		switch (selectedItem as! Item).type.identifier
		{
		case LocalItemType.InternalItemType.folder.identifier:
			self.navigationController?.pushViewController(ItemListViewController(item: selectedItem as! Item), animated: true)
			break
		default:
			self.navigationController?.pushViewController(ItemEditorViewController(item: selectedItem as! Item), animated: true)
			break
		}
	}
}
