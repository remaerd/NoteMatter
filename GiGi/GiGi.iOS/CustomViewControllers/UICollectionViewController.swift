//
//  UICollectionViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class UICollectionViewBackgroundView: UICollectionReusableView
{
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		layer.cornerRadius = Constants.defaultCornerRadius
		backgroundColor = Theme.colors[0]
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse()
	{
		super.prepareForReuse()
		backgroundColor = Theme.colors[0]
	}
}

class UICollectionViewFlowLayout: UIKit.UICollectionViewFlowLayout
{
	override init()
	{
		super.init()
		minimumLineSpacing = 0
		minimumInteritemSpacing = 0
		scrollDirection = .vertical
		sectionInset = UIEdgeInsets(top: 0, left: Constants.edgeMargin, bottom: 0, right: Constants.edgeMargin)
		headerReferenceSize = CGSize(width: 0, height: UIScreen.main.bounds.height - Defaults.listHeight.float)
		footerReferenceSize = CGSize(width: 0, height: Constants.edgeMargin)
		register(UICollectionViewBackgroundView.self, forDecorationViewOfKind: "background")
	}
	
	override func prepare()
	{
		super.prepare()
		guard let collectionView = self.collectionView else { return }
		estimatedItemSize = CGSize(width: collectionView.bounds.width - Constants.edgeMargin * 2, height: Constants.cellHeight)
		print(estimatedItemSize)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
	{
		guard let attributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
		var result = attributesArray
		for attributes in attributesArray
		{
			if attributes.representedElementCategory != .cell { break }
			let decoration = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "background", with: attributes.indexPath)
			var frame = attributes.frame
			// 若这个不是最后的内容，则延长一下背景，让他感觉是连在一起的
			if collectionView?.numberOfItems(inSection: attributes.indexPath.section) != attributes.indexPath.row + 1
			{ frame.size.height += Constants.cellHeight }
			decoration.frame = frame
			decoration.zIndex -= 1
			print(attributes)
			result.append(decoration)
		}
		return result
	}
}

class UICollectionViewController: UIKit.UICollectionViewController, EnhancedViewController
{
	var headerHeight: CGFloat { return UIScreen.main.bounds.height - Defaults.listHeight.float }
	
	var backgroundTintColor : UIColor { return Theme.colors[1] }
	var pushTransition : TransitionType { return TransitionType.default }
	var popTransition : TransitionType { return TransitionType.default }
	var searchPlaceHolder : String? { return nil }
	weak var searchDelegate: SearchBarDelegate? { return nil }
	
//	let maskLayer = CALayer()
//	let scrollMaskLayer = CALayer()
//	let maskView = UIView()
	
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
		
		customBackButton()
//		maskLayer.cornerRadius = Constants.defaultCornerRadius
//		maskLayer.backgroundColor = UIColor.black.cgColor
//		scrollMaskLayer.backgroundColor = UIColor.black.cgColor
		automaticallyAdjustsScrollViewInsets = false
		if #available(iOS 11.0, *) { collectionView?.contentInsetAdjustmentBehavior = .never }
		
//		maskView.layer.addSublayer(maskLayer)
//		maskView.layer.addSublayer(scrollMaskLayer)
		
//		collectionView?.mask = maskView
		collectionView!.alwaysBounceVertical = true
		collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
		collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		collectionView!.tintColor = Theme.colors[6]
		collectionView!.backgroundColor = Theme.colors[1]
//		renderMask()
	}
	
	override func viewWillLayoutSubviews()
	{
		super.viewWillLayoutSubviews()
//		renderMask()
	}
	
//	func renderMask()
//	{
//		let maskY = Constants.searchBarHeight + Constants.edgeMargin * 2 + Constants.statusBarHeight
//		var maskHeaderHeight = headerHeight - maskY - collectionView!.contentOffset.y
//		if (maskHeaderHeight < 0) { maskHeaderHeight = 0 }
//		var maskIndex = collectionView!.numberOfItems(inSection: 0)
//		var maskHeight = (CGFloat)(maskIndex) * Constants.cellHeight
//		if maskHeight < Defaults.listHeight.float - Constants.edgeMargin { maskHeight = Defaults.listHeight.float - Constants.edgeMargin }
//		maskView.frame = CGRect(origin: CGPoint(x: 0, y: collectionView!.contentOffset.y + maskHeaderHeight + maskY), size: collectionView!.bounds.size)
//		maskLayer.frame = CGRect(x: Constants.edgeMargin, y: 0, width: collectionView!.bounds.size.width - Constants.edgeMargin * 2, height: maskHeight)
//	}
	
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
