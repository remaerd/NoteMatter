//
//  DatabaseViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/11/2017.
//

import UIKit
import LocalAuthentication

class DatabaseViewController: UICollectionViewController
{
	enum AuthType
	{
		case password
		case touchId
		case faceId
	}
	
	var authType = AuthType.password
	
	override func loadView()
	{
		super.loadView()
		title = ".preferences.database".localized
		collectionView?.register(Cell.self, forCellWithReuseIdentifier: "cell")
		collectionView?.register(SwitchCell.self, forCellWithReuseIdentifier: "switcher")
		
		let context = LAContext()
		var error: NSError?
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
		{
			if #available(iOS 11.0.1, *)
			{
				switch context.biometryType
				{
				case .faceID: authType = .faceId
				case .touchID: authType = .touchId
				default: break
				}
			} else { authType = .touchId }
		}
	}
}

extension DatabaseViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 2
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if (section == 0) { return 3 }
		else
		{
			if authType != .password { return 2 }
			else { return 1 }
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		var cell : Cell!
		if indexPath.section == 0
		{
			switch indexPath.row
			{
			case 0:
				cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
				cell.titleTextfield.text = ".preferences.database.icloud".localized
				break
			case 1:
				cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
				cell.titleTextfield.text = ".preferences.database.import".localized
				break
			case 2:
				cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
				cell.titleTextfield.text = ".preferences.database.export".localized
				break
			default: break
			}
		}
		else
		{
			switch indexPath.row
			{
			case 0:
				cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
				cell.titleTextfield.text = ".preferences.database.password".localized
				break
			case 1:
				cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
				if authType == .faceId { cell.titleTextfield.text = ".preferences.database.faceid".localized }
				else if authType == .touchId { cell.titleTextfield.text = ".preferences.database.touchid".localized }
				break
			default: break
			}
		}
		return cell
	}
}
