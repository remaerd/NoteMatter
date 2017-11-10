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
	
	var renameConfirmAction: UIAlertAction?
	var renameTextfield: UITextField?
	
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
		enableAddButton()
		collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
		notificationToken = self.item.children.observe
		{ (_) in
			self.collectionView?.reloadData()
		}
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(true)
		addButton?.backgroundColor = Theme.colors[5]
		addButton?.imageView.tintColor = Theme.colors[0]
		self.collectionView?.reloadData()
	}
	
	deinit
	{
		notificationToken?.invalidate()
	}
}

