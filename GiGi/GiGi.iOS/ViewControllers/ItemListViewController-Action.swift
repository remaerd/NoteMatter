//
//  ItemListViewController-Action.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 13/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

extension ItemListViewController: EdgeActionDelegate
{
	func rightEdgeActionController() -> UICollectionViewController
	{
		return ItemCreatorViewController(item: self.item)
	}
}

extension ItemListViewController: ItemActionDelegate
{
	func itemActionController(forCell cell: ItemCell) -> UICollectionViewController
	{
		guard let indexPath = collectionView?.indexPath(for: cell) else { fatalError() }
		return ItemActionListViewController(item: self.item.children![indexPath.row])
	}
}

extension ItemListViewController: UITextFieldDelegate
{
	func renameItemAtIndexPath()
	{
		guard let indexPath = renameIndexPath else { return }
		guard let cell = collectionView?.cellForItem(at: indexPath) as? ItemCell else { return }
		cell.titleTextfield.tintColor = Theme.colors[8]
		cell.titleTextfield.isUserInteractionEnabled = true
		cell.titleTextfield.returnKeyType = .done
		cell.titleTextfield.delegate = self
		cell.titleTextfield.selectAll(nil)
		cell.titleTextfield.becomeFirstResponder()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		textField.isUserInteractionEnabled = false
		let _item = item.children![renameIndexPath!.row]
		do
		{
			_item.title = textField.text!
			try _item.save()
			renameIndexPath = nil
			return true
		}
		catch
		{
			error.alert()
			return false
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField)
	{
		
	}
}
