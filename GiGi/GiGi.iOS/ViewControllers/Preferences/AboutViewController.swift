//
//  AboutViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 20/1/2018.
//

import UIKit

class AboutViewController: UICollectionViewController
{
	override func loadView()
	{
		super.loadView()
		self.title = ".preferences.about".localized
		
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}
}

extension AboutViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 2
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if section == 0 { return 3 }
		else { return 4 }
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		if indexPath.section == 0
		{
			switch indexPath.row
			{
			case 0: cell.titleTextfield.text = ".preferences.about.email".localized; break
			case 1: cell.titleTextfield.text = ".preferences.about.twitter".localized; break
			case 2: cell.titleTextfield.text = ".preferences.about.weibo".localized; break
			default: break
			}
		}
		else
		{
			switch indexPath.row
			{
			case 0: cell.titleTextfield.text = ".preferences.about.releases".localized; break
			case 1: cell.titleTextfield.text = ".preferences.about.credits".localized; break
			case 2: cell.titleTextfield.text = ".preferences.about.licenses".localized; break
			case 3: cell.titleTextfield.text = ".preferences.about.privacy".localized; break
			default: break
			}
			cell.accessoryType = Cell.AccessoryType.default
		}
		return cell;
	}
}
