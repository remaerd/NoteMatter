//
//  SearchViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 09/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi
import Cartography

class SearchViewController: UIViewController
{
	var item: Item?
	var results: [Item]?
	var resultsCollectionView: UICollectionView

	override var pushTransition: TransitionType { return .bottom }
	override var popTransition : TransitionType { return .bottom }
	override weak var searchDelegate: SearchBarDelegate? { return self }

	init()
	{
		let layout = UICollectionViewFlowLayout()
		resultsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView()
	{
		super.loadView()
		title = ".placeholder.search".localized
		view.addSubview(resultsCollectionView)
		resultsCollectionView.alwaysBounceVertical = true
		resultsCollectionView.keyboardDismissMode = .interactive
		resultsCollectionView.backgroundColor = Theme.colors[0]
		resultsCollectionView.layer.cornerRadius = Constants.defaultCornerRadius
		resultsCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
		
		constrain(resultsCollectionView)
		{
			view in
			view.leading == view.superview!.leading
			view.trailing == view.superview!.trailing
			view.bottom == view.superview!.bottom
			view.top == view.superview!.top + Constants.statusBarHeight + Constants.edgeMargin * 2 + Constants.searchBarHeight
		}
	}
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
	func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if let results = results { return results.count } else { return 0 }
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

extension SearchViewController: SearchBarDelegate
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

	}
}
