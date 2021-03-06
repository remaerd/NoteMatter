//
//  IconListViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 09/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi
import Cartography

class IconListViewController: UIViewController
{
	let iconsView: UICollectionView
	var icons = ["Icon-Default", "Icon-Empiricism", "Icon-Rationalism", "Icon-Idealism",
							 "Icon-Pragmatism", "Icon-Perfectionism", "Icon-Altruism", "Icon-Elitism"]
	
	init()
	{
		let itemHeight = Constants.bigButtonSize + Constants.itemButtonDescriptionHeight + Constants.edgeMargin
		let layout = UIKit.UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: Constants.bigButtonSize, height: itemHeight)
		layout.minimumLineSpacing = Constants.itemButtonLineMargin
		layout.minimumInteritemSpacing = Constants.itemButtonColumnMargin
		iconsView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView()
	{
		super.loadView()
		
		title = ".preferences.icons".localized
		
		view.addSubview(iconsView)
		iconsView.delegate = self
		iconsView.dataSource = self
		iconsView.alwaysBounceVertical = true
		iconsView.keyboardDismissMode = .interactive
		iconsView.backgroundColor = Theme.colors[0]
		iconsView.layer.cornerRadius = Constants.defaultCornerRadius
		iconsView.register(IconCell.self, forCellWithReuseIdentifier: "cell")
		
		let margin = (view.bounds.width - (Constants.bigButtonSize * Constants.numberOfIconsPerRow) - (Constants.itemButtonColumnMargin * Constants.numberOfIconsPerRow - 1) - Constants.edgeMargin * 2) / 2
		
		let layout = iconsView.collectionViewLayout as! UIKit.UICollectionViewFlowLayout
		layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
		
		constrain(iconsView)
		{
			iconsView in
			iconsView.leading == iconsView.superview!.leading + Constants.edgeMargin
			iconsView.trailing == iconsView.superview!.trailing - Constants.edgeMargin
			iconsView.bottom == iconsView.superview!.bottom - Constants.edgeMargin
			iconsView.top == iconsView.superview!.top + (view.bounds.height - Defaults.listHeight.float - Constants.edgeMargin)
		}
	}
}

extension IconListViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
	func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return icons.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IconCell
		cell.iconView.image = UIImage(named: icons[indexPath.row])
		cell.descriptionLabel.text = icons[indexPath.row].localized
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		
	}
}
