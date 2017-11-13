//
//  ItemListViewController-Action.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 13/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

extension ItemListViewController: ItemCellDelegate
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
	
	@objc func itemCell(_ cell: ItemCell, didTriggerAction index: Int)
	{
		if let actions = cell.actions, let indexPath = collectionView?.indexPath(for: cell)
		{
			let selectedItem = item.children[indexPath.row]
			
			func rescheduleItem()
			{
				
			}
			
			func shareItem()
			{
				
			}
			
			func moveItem()
			{
				
			}
			
			func convertItem()
			{
				
			}
			
			func renameItem()
			{
				let alertController = UIAlertController(title: ".alert.rename.title".localized, message: nil, preferredStyle: .alert)
				alertController.addTextField(configurationHandler:
					{ (textfield) in
						NotificationCenter.default.addObserver(self, selector: #selector(self.textfieldDidChanged), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
						textfield.text = selectedItem.title
						self.renameTextfield = textfield
				})
				
				self.renameConfirmAction = UIAlertAction(title: ".alert.rename.confirm".localized, style: .default, handler:
					{ (_) in
						do { try Application.shared.database.write { if let text = self.renameTextfield?.text { selectedItem.title = text } } } catch { error.alert() }
						self.finish()
				})
				
				let cancelAction = UIAlertAction(title: ".alert.rename.cancel".localized, style: .cancel, handler:
				{ (_) in
					self.finish()
				})
				
				alertController.addAction(self.renameConfirmAction!)
				alertController.addAction(cancelAction)
				UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
			}
			
			func deleteItem()
			{
				do { try Application.shared.database.write { Application.shared.database.delete(selectedItem) }} catch { error.alert() }
			}
			
			switch actions[index]
			{
			case .reschedule: rescheduleItem(); break
			case .move: moveItem(); break
			case .convert: convertItem(); break
			case .rename: renameItem(); break
			case .delete: deleteItem(); break
			case .cancel: return
			}
		}
	}
}
