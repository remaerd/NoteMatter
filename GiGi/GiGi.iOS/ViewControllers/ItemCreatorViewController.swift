//
//  ItemCreatorViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 09/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation
import UIKit
import GiGi
import RealmSwift

class ItemCreatorViewController: UIViewController
{
	override var searchPlaceHolder : String? { return "item.title" }
	override weak var searchDelegate: SearchBarDelegate? { return self }

	let item: Item
	var itemTypes: Results<LocalItemType>
	var itemTypesCollectionView: UICollectionView
	var newItemTitle: String = ""
	let index: Int

	init(item: Item, index: Int = 0)
	{
		self.item = item
		self.index = index
		self.itemTypes = Application.shared.database.objects(LocalItemType.self)

		let itemHeight = Constants.bigButtonSize + Constants.itemButtonDescriptionHeight + Constants.edgeMargin
		let margin = (UIScreen.main.bounds.width - (Constants.bigButtonSize * Constants.numberOfItemTypesPerRow) - (Constants.itemButtonColumnMargin * Constants.numberOfItemTypesPerRow - 1)) / 2

		let itemTypesLayout = UIKit.UICollectionViewFlowLayout()
		itemTypesLayout.itemSize = CGSize(width: Constants.bigButtonSize, height: itemHeight)
		itemTypesLayout.minimumLineSpacing = Constants.itemButtonLineMargin
		itemTypesLayout.minimumInteritemSpacing = Constants.itemButtonColumnMargin
		itemTypesLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
		itemTypesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: itemTypesLayout)

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView()
	{
		super.loadView()
		view.addSubview(itemTypesCollectionView)
		itemTypesCollectionView.delegate = self
		itemTypesCollectionView.dataSource = self
		itemTypesCollectionView.alwaysBounceVertical = true
		itemTypesCollectionView.keyboardDismissMode = .interactive
		itemTypesCollectionView.backgroundColor = Theme.colors[0]
		itemTypesCollectionView.layer.cornerRadius = Constants.defaultCornerRadius
		itemTypesCollectionView.register(ItemTypeCell.self, forCellWithReuseIdentifier: "cell")
		itemTypesCollectionView.translatesAutoresizingMaskIntoConstraints = false
		itemTypesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		itemTypesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		itemTypesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		itemTypesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.statusBarHeight + Constants.edgeMargin * 2 + Constants.searchBarHeight).isActive = true
	}
}

extension ItemCreatorViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
	func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return itemTypes.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let item = itemTypes[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemTypeCell

		let color: UIColor
		switch item.genre
		{
		case ItemTypeGenre.system.rawValue: color = Theme.colors[7]; break
		case ItemTypeGenre.legal.rawValue: color = Theme.colors[8]; break
		case ItemTypeGenre.creation.rawValue: color = Theme.colors[9]; break
		case ItemTypeGenre.life.rawValue: color = Theme.colors[10]; break
		case ItemTypeGenre.health.rawValue: color = Theme.colors[11]; break
		case ItemTypeGenre.work.rawValue: color = Theme.colors[12]; break
		case ItemTypeGenre.business.rawValue: color = Theme.colors[13]; break
		default: color = Theme.colors[14]; break
		}
		cell.iconView.backgroundColor = color
		cell.iconView.tintColor = Theme.colors[1]
		cell.descriptionLabel.text = item.title?.localized

		if let icon = item.icon, let iconImage = UIImage(named:icon) { cell.iconView.image = iconImage }
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		let itemType = itemTypes[indexPath.row]
		do
		{
			try Application.shared.database.write
			{
				let item = Item(parent: self.item, itemType: itemType, title: newItemTitle, index: index)
				Application.shared.database.add(item)
			}
			navigationController?.popViewController(animated: true)
		} catch { print(error) }
	}

}

extension ItemCreatorViewController: SearchBarDelegate
{
	func searchBarDidTappedCloseButton(_ searchBar: SearchBar)
	{
		navigationController?.popViewController(animated: true)
	}

	func searchBarDidTappedSearchButton(_ searchBar: SearchBar)
	{

	}

	func searchBarDidChanged(_ searchBar: SearchBar, content: String)
	{
		newItemTitle = content
	}
}
