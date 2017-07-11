//
//  ItemListViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi
import RealmSwift

class ItemListViewController: UICollectionViewController
{
	override var searchPlaceHolder : String? { return item.title }

	var notificationToken: NotificationToken?
	var newInsertIndexPath: IndexPath?
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
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
		let button = addDragableButton()
		button.delegate = self
		notificationToken = self.item.children.addNotificationBlock
		{ (changes) in
			print(changes)
			self.collectionView?.reloadData()
		}
	}

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(true)
		self.collectionView?.reloadData()
	}

	deinit
	{
		notificationToken?.stop()
	}
}

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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell

		if let placeholderIndexPath = newInsertIndexPath, placeholderIndexPath.row == indexPath.row
		{
			cell.backgroundColor = Theme.colors[3]
			cell.titleLabel.text = ".item.insert".localized
			cell.tintColor = Theme.colors[0]
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
				cell.accessory = Cell.AccessoryType.action
				cell.titleLabel.text = childItem.title
				cell.tintColor = Theme.colors[6]
			} else
			{
				cell.titleLabel.text = ".item.preferences".localized
				cell.accessory = Cell.AccessoryType.arrow
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

extension ItemListViewController: DragableButtonDelegate
{
	func shouldEnd(dragableButton: DragableButton, toPoint: CGPoint) -> Bool
	{
		if let indexPath = newInsertIndexPath
		{
			newInsertIndexPath = nil
			let viewController = ItemCreatorViewController(item: item, index: indexPath.row)
			navigationController?.pushViewController(viewController, animated: true)
			return false
		} else { return false }
	}

	func didTapped(dragableButton: DragableButton)
	{
		let creatorViewController = ItemCreatorViewController(item:item)
		self.navigationController?.pushViewController(creatorViewController, animated: true)
	}

	func didPanned(dragableButton: DragableButton, toPoint: CGPoint)
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
		} else
		{
			if let insertedIndexPath = newInsertIndexPath
			{
				newInsertIndexPath = nil
				collectionView?.deleteItems(at: [insertedIndexPath])
			}
		}
	}
}
