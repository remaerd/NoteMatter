//
//  ItemListViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class ItemListViewController: UICollectionViewController
{
	override var searchPlaceHolder : String? { return item.title }

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
	}
}

extension ItemListViewController: DragableButtonDelegate
{
	func shouldEnd(dragableButton: DragableButton, toPoint: CGPoint) -> Bool
	{
		return true
	}

	func didTapped(dragableButton: DragableButton)
	{
		let creatorViewController = ItemCreatorViewController(item:item)
		self.navigationController?.pushViewController(creatorViewController, animated: true)
	}

	func didPanned(dragableButton: DragableButton, toPoint: CGPoint)
	{

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
		if (self.item.identifier == Item.InternalItem.rootFolder.identifier) { return item.children.count + 1 } else { return item.children.count }
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell

		if (indexPath.row < item.children.count)
		{
			if let icon = item.children[indexPath.row].itemType.icon, let image = UIImage(named: icon) { cell.icon = image }
			cell.titleLabel.text = item.children[indexPath.row].title
			cell.accessory = Cell.AccessoryType.arrow
			cell.tintColor = Theme.colors[6]
		} else
		{
			cell.titleLabel.text = ".item.preferences".localized
			cell.accessory = Cell.AccessoryType.arrow
			cell.icon = UIImage(named:"List-Preferences")
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
