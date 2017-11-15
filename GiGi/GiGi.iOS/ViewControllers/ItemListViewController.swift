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
	var renameConfirmAction: UIAlertAction?
	var renameTextfield: UITextField?
	
	var newInsertIndexPath: IndexPath?
	let item: Item
	
	init(item: Item)
	{
		self.item = item
		super.init()
		title = item.title.localized
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		
		navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Plus"), style: .plain, target: self, action: #selector(didTappAddButton))]
		navigationItem.leftBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Menu"), style: .plain, target: self, action: #selector(didTappMenuButton))]
		collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(true)
		self.collectionView?.reloadData()
	}
	
	deinit
	{
		
	}
}

extension ItemListViewController
{
	@objc func didTappAddButton()
	{
		navigationController?.pushViewController(ItemCreatorViewController(item: self.item), animated: true)
	}
	
	@objc func didTappMenuButton()
	{
		navigationController?.pushViewController(PreferencesViewController(), animated: true)
	}
}
