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
		return item.solution.actions.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		if let icon = item.solution.actions[indexPath.row].icon { cell.icon = UIImage(named: icon) } else { cell.icon = UIImage() }
		cell.titleLabel.text = item.solution.actions[indexPath.row].title.localized
		cell.tintColor = Theme.colors[7]
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
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
			
		}

		func deleteItem()
		{
			do { try item.destroy() } catch { error.alert() }
		}
		
		switch item.solution.actions[indexPath.row]
		{
		case .reschedule: rescheduleItem(); break
		case .move: moveItem(); break
		case .convert: convertItem(); break
		case .rename: renameItem(); break
		case .delete: deleteItem(); break
		case .cancel: if !isSlideActionModeEnable { navigationController?.popViewController(animated: true) }
		}
	}
}
