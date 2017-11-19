//
//  SecurityViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 15/11/2017.
//

import UIKit
import LocalAuthentication

class SecurityViewController: UICollectionViewController
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
		title = ".preferences.security".localized
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
				case .typeFaceID: authType = .faceId
				case .typeTouchID: authType = .touchId
				default: break
				}
			} else { authType = .touchId }
		}
	}
}

extension SecurityViewController
{
	override func numberOfSections(in collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
	{
		if authType != .password { return 2 }
		else { return 1 }
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
	{
		var cell : Cell!
		switch indexPath.row
		{
		case 0:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
			cell.titleLabel.text = ".preferences.security.reset".localized
			break
		case 1:
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: "switcher", for: indexPath) as! SwitchCell
			if authType == .faceId { cell.titleLabel.text = ".preferences.security.faceid".localized }
			else if authType == .touchId { cell.titleLabel.text = ".preferences.security.touchid".localized }
			break
		default: break
		}
		return cell
	}
}
