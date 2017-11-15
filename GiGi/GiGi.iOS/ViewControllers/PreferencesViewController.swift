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
	override var pushTransition: TransitionType { return .right }
	override var popTransition : TransitionType { return .left }
	
  let menuNames = [".preferences.assistant", ".preferences.icons", ".preferences.solutions",
                   ".preferences.experience", ".preferences.extensions", ".preferences.security"]

	let menuIcons = ["List-Assistant","List-Badges","List-Solution","List-Experiences","List-Extensions","List-Security"]

	override func loadView()
	{
		super.loadView()
		title = ".item.preferences".localized
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
	}

	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 2
	}

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if section == 0 { return 1 }
		return menuNames.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		cell.tintColor = Theme.colors[6]
		cell.accessoryType = .default
		if indexPath.section == 0
		{
			cell.titleLabel.text = ".preferences.membership".localized
			cell.icon = #imageLiteral(resourceName: "List-Membership")
		}
		else
		{
			cell.titleLabel.text = menuNames[indexPath.row].localized
			cell.icon = UIImage(named: menuIcons[indexPath.row])
		}
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		if indexPath.section == 0
		{
			navigationController?.pushViewController(MembershipViewController(), animated: true)
		}
		else
		{
			switch indexPath.row
			{
			case 0: navigationController?.pushViewController(AssistantViewController(), animated: true); break
			case 1: navigationController?.pushViewController(IconListViewController(), animated: true); break
			case 2: navigationController?.pushViewController(SolutionListViewController(), animated: true); break
			case 3: navigationController?.pushViewController(ExperienceViewController(), animated: true); break
			case 4: navigationController?.pushViewController(ExtensionViewController(), animated: true); break
			case 5: navigationController?.pushViewController(SecurityViewController(), animated: true); break
			default: break
			}
		}
	}
}
