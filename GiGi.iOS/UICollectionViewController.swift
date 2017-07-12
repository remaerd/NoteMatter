//
//  UICollectionViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class UICollectionViewController: UIKit.UICollectionViewController, EnhancedViewController
{
	var headerHeight: CGFloat { return UIScreen.main.bounds.height - Defaults.listHeight.float }

	var backgroundTintColor : UIColor { return Theme.colors[1] }
	var pushTransition : TransitionType { return TransitionType.default }
	var popTransition : TransitionType { return TransitionType.default }
	var searchPlaceHolder : String? { return nil }
	weak var searchDelegate: SearchBarDelegate? { return nil }

	let maskLayer = CALayer()
	let scrollMaskLayer = CALayer()
	let maskView = UIView()

	static var defaultLayout : UICollectionViewFlowLayout
	{
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.edgeMargin, bottom: 0, right: Constants.edgeMargin)
		layout.itemSize = CGSize(width: UIScreen.main.bounds.width - Constants.edgeMargin * 2, height: Constants.cellHeight)
		layout.scrollDirection = .vertical
		layout.headerReferenceSize = CGSize(width: 0, height: UIScreen.main.bounds.height - Defaults.listHeight.float)
		layout.footerReferenceSize = CGSize(width: 0, height: Constants.edgeMargin + Constants.defaultCornerRadius)
		return layout
	}

	override init(collectionViewLayout layout: UICollectionViewLayout = UICollectionViewController.defaultLayout)
	{
		super.init(collectionViewLayout: layout)
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView()
	{
		super.loadView()

		customBackButton()
		maskLayer.cornerRadius = Constants.defaultCornerRadius
		maskLayer.backgroundColor = UIColor.black.cgColor
		scrollMaskLayer.backgroundColor = UIColor.black.cgColor
		automaticallyAdjustsScrollViewInsets = false
		if #available(iOS 11.0, *)
		{
			collectionView?.contentInsetAdjustmentBehavior = .never
		} else {
			// Fallback on earlier versions
		}

		maskView.layer.addSublayer(maskLayer)
		maskView.layer.addSublayer(scrollMaskLayer)

		collectionView?.mask = maskView
		collectionView!.alwaysBounceVertical = true
		collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
		collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
	}

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		collectionView!.tintColor = Theme.colors[6]
		collectionView!.backgroundColor = Theme.colors[0]
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
		var maskHeaderHeight = headerHeight - maskY - collectionView!.contentOffset.y
		if (maskHeaderHeight < 0) { maskHeaderHeight = 0 }
		var maskHeight = (CGFloat)(collectionView!.numberOfItems(inSection: 0)) * Constants.cellHeight
		if maskHeight < Defaults.listHeight.float - Constants.edgeMargin { maskHeight = Defaults.listHeight.float - Constants.edgeMargin }
		maskView.frame = CGRect(origin: CGPoint(x: 0, y: collectionView!.contentOffset.y + maskHeaderHeight + maskY), size: collectionView!.bounds.size)
		maskLayer.frame = CGRect(x: Constants.edgeMargin, y: 0, width: collectionView!.bounds.size.width - Constants.edgeMargin * 2, height: maskHeight)
//		scrollMaskLayer.frame = CGRect(x: collectionView!.bounds.width - 10, y: 0 ,width: 10, height: collectionView!.bounds.height)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		if backgroundTintColor.isVisibleOnWhiteBackground == false { return UIStatusBarStyle.default }
		return UIStatusBarStyle.lightContent
	}

	override var supportedInterfaceOrientations: UIInterfaceOrientationMask
	{
		return [.portrait, .portraitUpsideDown]
	}

	override var shouldAutorotate: Bool { return false }
}

extension UICollectionViewController
{
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
	{
		let view: UICollectionReusableView
		if (kind == UICollectionElementKindSectionHeader) { view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) } else
		{
			view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
		}
		return view
	}
}
