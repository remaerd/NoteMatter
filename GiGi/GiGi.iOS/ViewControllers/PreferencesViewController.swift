//
//  PreferencesViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

class PreferencesViewController: UICollectionViewController
{
	override var pushTransition: TransitionType { return .bottom }
	override var popTransition : TransitionType { return .bottom }
	
  let menuNames = [".preferences.assistant", ".preferences.icons", ".preferences.experience", ".preferences.extensions", ".preferences.database"]
	let menuIcons = ["List-Assistant","List-Badges","List-Experiences","List-Extensions","List-Database"]

	override func loadView()
	{
		super.loadView()
		
		title = ".item.preferences".localized
		
		let item = UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Close"), style: .plain, target: self, action: #selector(didTappedCloseButton))
		item.title = ".item.rootFolder".localized
		navigationItem.leftBarButtonItem = item
		
		let aboutItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Navigation-Info"), style: .plain, target: self, action: #selector(didTappedInfoButton))
		aboutItem.title = ".preferences.about".localized
		navigationItem.rightBarButtonItem = aboutItem

		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
		collectionView?.register(SwitchCell.self, forCellWithReuseIdentifier: "switcher")
		collectionView?.register(MonoDashboardView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier:"dashboard")
	}
	
	@objc func didTappedCloseButton()
	{
		Sound.tapNavButton.play()
		navigationController?.popViewController(animated: true)
	}
	
	@objc func didTappedInfoButton()
	{
		Sound.tapNavButton.play()
		navigationController?.pushViewController(AboutViewController(), animated: true)
	}
}

extension PreferencesViewController
{
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
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		cell.titleTextfield.text = menuNames[indexPath.row].localized
		cell.icon = UIImage(named: menuIcons[indexPath.row])
		cell.tintColor = Theme.colors[6]
		cell.accessoryType = .default
		if indexPath.row == 0
		{
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			cell.titleTextfield.text = menuNames[indexPath.row].localized
			cell.icon = UIImage(named: menuIcons[indexPath.row])
			cell.switcher.isOn = Defaults.assistant.bool
		}
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		Sound.tapCell.play()
		switch indexPath.row
		{
		case 0: navigationController?.pushViewController(AssistantViewController(), animated: true); break
		case 1: navigationController?.pushViewController(IconListViewController(), animated: true); break
		case 2: navigationController?.pushViewController(ExperienceViewController(), animated: true); break
		case 3: navigationController?.pushViewController(ExtensionViewController(), animated: true); break
		case 4: navigationController?.pushViewController(DatabaseViewController(), animated: true); break
		default: break
		}
	}
}
