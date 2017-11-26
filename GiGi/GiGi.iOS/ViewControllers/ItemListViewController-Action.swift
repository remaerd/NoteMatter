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

extension ItemListViewController
{
	@objc func textfieldDidChanged()
	{
		if renameTextfield!.text == nil { self.renameConfirmAction?.isEnabled = false } else { self.renameConfirmAction?.isEnabled = true }
	}
	
	func finish()
	{
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
		self.renameTextfield = nil
		self.renameConfirmAction = nil
	}
}
