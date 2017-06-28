//
//  UICollectionViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 28/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class UICollectionViewController: UIKit.UICollectionViewController
{
	let maskLayer = CALayer()
	let scrollMaskLayer = CALayer()
	let maskView = UIView()
	static let headerHeight = UIScreen.main.bounds.height - Defaults.listHeight.float - Constants.statusBarHeight

	static var defaultLayout : UICollectionViewFlowLayout
	{
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.edgeMargin, bottom: 0, right: Constants.edgeMargin)
		layout.itemSize = CGSize(width: UIScreen.main.bounds.width - Constants.edgeMargin * 2, height: Constants.cellHeight)
		layout.scrollDirection = .vertical
		layout.headerReferenceSize = CGSize(width: 0, height: headerHeight)
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

		maskLayer.cornerRadius = Constants.defaultCornerRadius
		maskLayer.backgroundColor = UIColor.black.cgColor
		scrollMaskLayer.backgroundColor = UIColor.black.cgColor

		maskView.layer.addSublayer(maskLayer)
		maskView.layer.addSublayer(scrollMaskLayer)

		collectionView!.tintColor = Theme.colors[6]
		collectionView!.backgroundColor = Theme.colors[1]
		collectionView!.alwaysBounceVertical = true
		collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
		collectionView!.register(FooterCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
	}

	override func viewWillLayoutSubviews()
	{
		super.viewWillLayoutSubviews()
		renderMask()
	}

	func renderMask()
	{
		let maskY = Constants.searchBarHeight + Constants.edgeMargin * 2 + Constants.statusBarHeight
		let maskHeaderHeight = UICollectionViewController.headerHeight - maskY - collectionView!.contentOffset.y
		maskView.frame = CGRect(origin: CGPoint(x: 0, y: collectionView!.contentOffset.y + maskHeaderHeight + maskY), size: collectionView!.bounds.size)
		maskLayer.frame = CGRect(x: Constants.edgeMargin, y: 0, width: collectionView!.bounds.size.width - Constants.edgeMargin * 2, height: collectionView!.bounds.height)
		scrollMaskLayer.frame = CGRect(x: collectionView!.bounds.width - 10, y: 0 ,width: 10, height: collectionView!.bounds.height)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		if view.backgroundColor?.isVisibleOnWhiteBackground() == true { return UIStatusBarStyle.default }
		return UIStatusBarStyle.lightContent
	}
}

extension UICollectionViewController
{
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
	{
		let view: UICollectionReusableView
		if (kind == UICollectionElementKindSectionHeader) { view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) } else
		{
			view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
			let height = Defaults.listHeight.float - (CGFloat)(collectionView.numberOfItems(inSection: 0)) * Constants.cellHeight - Constants.defaultCornerRadius
			if (height > Constants.defaultCornerRadius * 2) { (view as? FooterCell)?.cornerRadiusHeight = height }
		}
		return view
	}
}

class FooterCell: UICollectionReusableView
{
	let bottomCornerRadiusView = UIView()
	var heightConstraint: NSLayoutConstraint?

	var cornerRadiusHeight: CGFloat = Constants.defaultCornerRadius * 2
	{
		didSet { setConstraints() }
	}

	override init(frame: CGRect)
	{
		super.init(frame: frame)

		addSubview(bottomCornerRadiusView)
		bottomCornerRadiusView.backgroundColor = Theme.colors[0]
		bottomCornerRadiusView.layer.cornerRadius = Constants.defaultCornerRadius
		bottomCornerRadiusView.translatesAutoresizingMaskIntoConstraints = false
		bottomCornerRadiusView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.edgeMargin).isActive = true
		bottomCornerRadiusView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.edgeMargin).isActive = true
		bottomCornerRadiusView.topAnchor.constraint(equalTo: topAnchor, constant: -Constants.defaultCornerRadius).isActive = true
		setConstraints()
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	func setConstraints()
	{
		if let constraint = heightConstraint { bottomCornerRadiusView.removeConstraint(constraint) }
		heightConstraint = bottomCornerRadiusView.heightAnchor.constraint(equalToConstant: cornerRadiusHeight)
		heightConstraint?.isActive = true
	}
}
