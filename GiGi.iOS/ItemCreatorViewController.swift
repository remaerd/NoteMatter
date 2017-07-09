//
//  ItemCreatorViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 09/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class ItemCreatorViewController: UIViewController
{
	override var pushTransition: TransitionType { return .bottom }
	override var popTransition : TransitionType { return .bottom }
	override var searchPlaceHolder : String? { return "item.title" }
	override weak var searchDelegate: SearchBarDelegate? { return self }

	let item: Item
	var itemTypes: [ItemType]
	var itemTypesCollectionView: UICollectionView

	init(item: Item)
	{
		self.item = item
		self.itemTypes = []
		let itemTypesLayout = UICollectionViewFlowLayout()
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

	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{

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

	func searchBarDidChanged(_ searchBar: SearchBar, content: String?)
	{

	}
}
