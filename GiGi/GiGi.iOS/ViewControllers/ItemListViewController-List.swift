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
		
		if childItem.solution.isFolder { cell.itemType = .folder }
		else { cell.itemType = .default }
		
		cell.tintColor = Theme.colors[6]
		cell.taskButton.isSelected = (childItem.task.completedAt != nil)
		cell.titleTextfield.text = (childItem as AnyObject).title.localized
		cell.taskButton.addTarget(self, action: #selector(didTappedTaskButton(button:)), for: .touchUpInside)
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		let selectedItem = self.item.children![indexPath.row]
		Sound.tapCell.play()
		switch selectedItem.solution.identifier
		{
		case Solution.InternalSolution.folder.identifier:
			self.navigationController?.pushViewController(ItemListViewController(item: selectedItem), animated: true)
			break
		default:
			self.navigationController?.pushViewController(ItemTextEditorViewController(item: selectedItem), animated: true)
			break
		}
	}
}

extension ItemListViewController
{
	@objc func didTappedTaskButton(button: UIButton)
	{
		let cell = button.superview!.superview! as! ItemCell
		let indexPath = collectionView!.indexPath(for: cell)!
		let cellItem = item.children![indexPath.row]
		if (cellItem.task.completedAt != nil)
		{
			Sound.checkboxDeselect.play()
			cellItem.task.completedAt = nil
			cell.taskButton.isSelected = false
		}
		else
		{
			Sound.checkboxSelect.play()
			cellItem.task.completedAt = Date()
			cell.taskButton.isSelected = true
		}
		try! cellItem.task.save()
	}
}
