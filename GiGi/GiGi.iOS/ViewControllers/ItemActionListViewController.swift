//
//  ItemActionListViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 12/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class ItemActionListViewController: UICollectionViewController
{
	override var showCloseButton: Bool { return true }
	override var pushTransition : TransitionType { return TransitionType.right }
	override var popTransition : TransitionType { return TransitionType.left }
	
	let item: Item
	
	init(item: Item)
	{
		self.item = item
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		self.title = item.title
		self.clearsSelectionOnViewWillAppear = true
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}
}

extension ItemActionListViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return item.template.actions.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		if let icon = item.template.actions[indexPath.row].icon { cell.icon = UIImage(named: icon) } else { cell.icon = UIImage() }
		if item.template.actions[indexPath.row] == .more { cell.accessoryType = Cell.AccessoryType.default }
		cell.titleTextfield.text = item.template.actions[indexPath.row].title.localized
		cell.tintColor = Theme.colors[7]
		
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		Sound.tapCell.play()
		
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
			let index = (navigationController?.viewControllers.count)! - 2
			guard let controller = navigationController?.viewControllers[index] as? ItemListViewController else { return }
			controller.renameIndexPath = indexPath
		}

		func deleteItem()
		{
			do { try item.destroy() } catch { error.alert() }
		}
		
		switch item.template.actions[indexPath.row]
		{
		case .reschedule: rescheduleItem(); break
		case .move: moveItem(); break
		case .rename: renameItem(); break
		case .delete: deleteItem(); break
		case .more: shareItem(); break
		case .cancel: break
		default: break
		}
		
		if !isSlideActionModeEnable { navigationController?.popViewController(animated: true) }
	}
}
