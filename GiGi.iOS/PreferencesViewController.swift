//
//  PreferencesViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class PreferencesViewController: UICollectionViewController
{
  let menuNames = [".preferences.membership", ".preferences.assistant", ".preferences.experience",
                   ".preferences.solutions", ".preferences.ios", ".preferences.security", ".preferences.about"]

	let menuIcons = ["List-Membership","List-Assistant","List-Visual","List-Solution","List-iOS","List-Security"]

	override var searchPlaceHolder : String? { return ".item.preferences".localized }

	override func loadView()
	{
		super.loadView()
		collectionView?.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
	}

	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return menuNames.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
		cell.titleLabel.text = menuNames[indexPath.row].localized
		cell.accessory = ItemCell.AccessoryType.arrow
		cell.tintColor = Theme.colors[6]
		if (indexPath.row < menuIcons.count) { cell.icon = UIImage(named: menuIcons[indexPath.row]) } else { cell.icon = UIImage() }
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{

	}
}
