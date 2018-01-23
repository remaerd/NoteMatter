//
//  ItemListViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import CoreData
import UIKit
import GiGi

class ItemListViewController: UICollectionViewController
{
	override var dashboardType: AnyClass? { return MonoDashboardView.self }
	
	var renameIndexPath: IndexPath?
	let item: Item
	
	init(item: Item)
	{
		self.item = item
		super.init()
		title = item.title.localized
		item.addObserver { (object, change) in
			self.collectionView?.reloadData()
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		
		if item.title == Item.InternalItem.rootFolder.title
		{
			let item = UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Menu"), style: .plain, target: self, action: #selector(didTappMenuButton))
			item.title = ".item.preferences".localized
			navigationItem.leftBarButtonItem = item
		}
		let rightItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Plus"), style: .plain, target: self, action: #selector(didTappAddButton))
		rightItem.title = ".placeholder.new".localized
		navigationItem.rightBarButtonItem = rightItem
		
		collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		OperationQueue.main.addOperation
		{
			self.renameItemAtIndexPath()
		}
	}
	
	deinit
	{
		
	}
}

extension ItemListViewController
{
	@objc func didTappAddButton()
	{
		Sound.tapNavButton.play()
		navigationController?.pushViewController(ItemCreatorViewController(item: self.item), animated: true)
	}
	
	@objc func didTappMenuButton()
	{
		Sound.tapNavButton.play()
		navigationController?.pushViewController(PreferencesViewController(), animated: true)
	}
}
