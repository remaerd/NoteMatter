//
//  ExtensionViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/11/2017.
//

import UIKit

class ExtensionViewController: UICollectionViewController
{
	override func loadView()
	{
		super.loadView()

		title = ".preferences.extensions".localized
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
		collectionView?.register(SwitchCell.self, forCellWithReuseIdentifier: "switcher")
	}
}

extension ExtensionViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		return 6
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		switch indexPath.row
		{
		case 0:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
			cell.titleLabel.text = ".preferences.extensions.today".localized
			cell.accessoryType = Cell.AccessoryType.description(string: ".preferences.extensions.inactived".localized)
			cell.icon = #imageLiteral(resourceName: "List-Today")
			return cell
		case 1:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
			cell.titleLabel.text = ".preferences.extensions.share".localized
			cell.accessoryType = Cell.AccessoryType.description(string: ".preferences.extensions.inactived".localized)
			cell.icon = #imageLiteral(resourceName: "List-Share")
			return cell
		case 2:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.siri".localized
			cell.icon = #imageLiteral(resourceName: "List-Siri")
			return cell
		case 3:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.calendar".localized
			cell.icon = #imageLiteral(resourceName: "List-Calendar")
			return cell
		case 4:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.reminders".localized
			cell.icon = #imageLiteral(resourceName: "List-Reminders")
			return cell
		case 5:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleLabel.text = ".preferences.extensions.spotlight".localized
			cell.icon = #imageLiteral(resourceName: "List-Spotlight")
			return cell
		default: fatalError()
		}
	}
}


