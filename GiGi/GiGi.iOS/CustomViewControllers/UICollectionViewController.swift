//
//  UICollectionViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

class UICollectionViewFlowLayout: UIKit.UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout
{
	override init()
	{
		super.init()
		minimumLineSpacing = 0
		minimumInteritemSpacing = 0
		scrollDirection = .vertical
		sectionInset = UIEdgeInsets(top: 0, left: Constants.edgeMargin, bottom: 0, right: Constants.edgeMargin)
		footerReferenceSize = CGSize(width: 0, height: Constants.edgeMargin)
	}
	
	override func prepare()
	{
		super.prepare()
		guard let collectionView = self.collectionView else { return }
		estimatedItemSize = CGSize(width: collectionView.bounds.width - Constants.edgeMargin * 2, height: Constants.cellHeight)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

protocol EdgeActionDelegate
{
	func rightEdgeActionController() -> UICollectionViewController
}

protocol ItemActionDelegate
{
	func itemActionController(forCell cell: ItemCell) -> UICollectionViewController
}

protocol RenameDelegate
{
	func renameItem(atIndex indexPath: NSIndexPath)
}

class UICollectionViewController: UIKit.UICollectionViewController, EnhancedViewController
{
	var isSlideActionModeEnable: Bool = false
	
	var showCloseButton: Bool { return false }
	var backgroundTintColor : UIColor { return Theme.colors[1] }
	var pushTransition : TransitionType { return TransitionType.default }
	var popTransition : TransitionType { return TransitionType.default }
	weak var searchDelegate: SearchBarDelegate? { return nil }
	var dashboardType: AnyClass? { return nil }
	
	let maskLayer = CALayer()
	let scrollMaskLayer = CALayer()
	let maskView = UIView()
	
	init()
	{
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		
		automaticallyAdjustsScrollViewInsets = false
		clearsSelectionOnViewWillAppear = true
		
		maskLayer.cornerRadius = Constants.defaultCornerRadius
		maskLayer.backgroundColor = UIColor.black.cgColor
		scrollMaskLayer.backgroundColor = UIColor.black.cgColor
		if #available(iOS 11.0, *) { collectionView?.contentInsetAdjustmentBehavior = .never }
		
		maskView.layer.addSublayer(maskLayer)
		maskView.layer.addSublayer(scrollMaskLayer)
		
		collectionView?.mask = maskView
		collectionView!.alwaysBounceVertical = true
		collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
		collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
		if let type = dashboardType { collectionView!.register(type, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "dashboard") }
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		collectionView?.reloadData()
		collectionView!.tintColor = Theme.colors[6]
		collectionView!.backgroundColor = Theme.colors[1]
		renderMask()
	}
	
	override func viewWillLayoutSubviews()
	{
		super.viewWillLayoutSubviews()
		renderMask()
	}
	
	func renderMask()
	{
		let maskY = Constants.searchBarHeight + Constants.edgeMargin * 2 + Constants.statusBarHeight
		maskView.frame = CGRect(origin: CGPoint(x: 0, y: collectionView!.contentOffset.y + maskY), size: collectionView!.bounds.size)
		maskLayer.frame = CGRect(x: Constants.edgeMargin, y: 0, width: collectionView!.bounds.size.width - Constants.edgeMargin * 2, height: UIScreen.main.bounds.height)
	}
	
	override var supportedInterfaceOrientations: UIInterfaceOrientationMask
	{
		return [.portrait, .portraitUpsideDown]
	}
	
	override var shouldAutorotate: Bool { return false }
}

extension UICollectionViewController: UICollectionViewDelegateFlowLayout
{
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
	{
		if section == 0 { return CGSize(width: 0, height: UIScreen.main.bounds.height - Defaults.listHeight.float ) }
		return CGSize.zero
	}
	
	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
	{
		if collectionView.numberOfItems(inSection: indexPath.section) == 1 { cell.backgroundView?.layer.cornerRadius = Constants.defaultCornerRadius }
		else
		{
			cell.backgroundView = UIView()
			cell.backgroundView?.backgroundColor = Theme.colors[0]
			if indexPath.row == 0 { cell.backgroundView?.setCornerRadius(corners: [.topLeft,.topRight], radius: Constants.edgeMargin) }
			else if collectionView.numberOfItems(inSection: indexPath.section) - 1 == indexPath.row
			{ cell.backgroundView?.setCornerRadius(corners: [.bottomLeft,.bottomRight], radius: Constants.edgeMargin) }
		}
	}
}

extension UICollectionViewController
{
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
	{
		var view: UICollectionReusableView
		if dashboardType != nil && kind == UICollectionElementKindSectionHeader && indexPath.section == 0
		{
			view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "dashboard", for: indexPath)
		}
		else if (kind == UICollectionElementKindSectionHeader)
		{
			view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
		}
		else
		{
			view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
		}
		return view
	}
}
