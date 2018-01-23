//
//  SearchBar.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: NSObjectProtocol
{
	func searchBarDidChanged(_ searchBar: SearchBar, content: String)
	func searchBarDidTappedSearchButton(_ searchBar: SearchBar)
	func searchBarDidTappedCloseButton(_ searchBar: SearchBar)
}

class SearchBar: UITextField
{
	weak var searchDelegate: SearchBarDelegate?

	var rightEdgeIndicator: EdgeIndicator? { didSet{ didSetIndicator(cornerType: .right) }}
	var leftEdgeIndicator: EdgeIndicator? { didSet{ didSetIndicator(cornerType: .left) }}
	var leftEdgeGesture: UIScreenEdgePanGestureRecognizer!
	var rightEdgeGesture: UIScreenEdgePanGestureRecognizer!
	
	var slideTransition: SlideTransition
	{
		let delegate = UIApplication.shared.delegate as? AppDelegate
		let navController = delegate?.window?.rootViewController as? UINavigationController
		return navController!.slideTransition
	}
	
	var rightButton: UIButton?
	{
		didSet { if rightButton != nil { rightView = rightButton } else { rightView = UIView() } }
	}

	override var placeholder: String?
	{
		didSet { placeholderDidChanged() }
	}

	override init(frame: CGRect)
	{
		super.init(frame: frame)
		delegate = self
		leftViewMode = .always
		rightViewMode = .always
		textAlignment = .center
		enablesReturnKeyAutomatically = true
		layer.cornerRadius = Constants.defaultCornerRadius
		if #available(iOS 9.0, *) { returnKeyType = .continue } else { returnKeyType = .search }
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func willMove(toSuperview newSuperview: UIView?)
	{
		super.willMove(toSuperview: newSuperview)
		guard let superview = newSuperview else { return }
		
		leftEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeDidPanned(gesture:)))
		leftEdgeGesture.minimumNumberOfTouches = 1
		leftEdgeGesture.maximumNumberOfTouches = 1
		leftEdgeGesture.edges = .left
		
		rightEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeDidPanned(gesture:)))
		rightEdgeGesture.minimumNumberOfTouches = 1
		rightEdgeGesture.maximumNumberOfTouches = 1
		rightEdgeGesture.edges = .right
		
		superview.addGestureRecognizer(leftEdgeGesture)
		superview.addGestureRecognizer(rightEdgeGesture)
	}
	
	func placeholderDidChanged()
	{
		guard let placeholder = placeholder else { return }
		attributedPlaceholder = NSAttributedString(string: placeholder.uppercased(), attributes: [.foregroundColor: Theme.colors[4], .font: Font.SearchBarTextFont, .kern: 1.1])
	}

	func reset(controller: UIKit.UIViewController)
	{
		if slideTransition.isStarted
		{
			rightButton = nil
			leftView = UIView()
			placeholder = ".placeholder.slide".localized
			return
		}
		
		func barButton(item: UIBarButtonItem) -> UIButton
		{
			let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: item.image!.size.width + 15, height: item.image!.size.height - 1)))
			button.tintColor = Theme.colors[4]
			button.setImage(item.image!, for: .normal)
			button.addTarget(item.target!, action: item.action!, for: .touchUpInside)
			return button
		}
		
		placeholder = controller.navigationItem.title
		if let item = controller.navigationItem.leftBarButtonItem
		{
			leftView = barButton(item: item)
			leftEdgeIndicator = EdgeIndicator(cornerType: .left, image: item.image!, title: item.title!, more: false)
			leftEdgeIndicator?.target = item.target
			leftEdgeIndicator?.action = item.action
			leftEdgeGesture.isEnabled = true
		}
		else
		{
			leftView = UIView()
			leftEdgeIndicator = nil
			leftEdgeGesture.isEnabled = false
		}
		
		if let item = controller.navigationItem.rightBarButtonItem
		{
			rightButton = barButton(item: item)
			let more : Bool
			if controller is EdgeActionDelegate { more = true } else { more = false }
			rightEdgeIndicator = EdgeIndicator(cornerType: .right, image: item.image!, title: item.title!, more: more)
			rightEdgeIndicator?.target = item.target
			rightEdgeIndicator?.action = item.action
			rightEdgeGesture.isEnabled = true
		}
		else
		{
			rightButton = nil
			rightEdgeGesture.isEnabled = false
			rightEdgeIndicator = nil
		}
	}

	func close()
	{
		if let view = leftView { view.isHidden = false }
		rightView = rightButton
		textAlignment = .center
		placeholderDidChanged()
		text = nil
	}
}

extension SearchBar: UITextFieldDelegate
{
	override func textRect(forBounds bounds: CGRect) -> CGRect
	{
		return bounds.insetBy(dx: 10, dy: 5)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect
	{
		return bounds.insetBy(dx: 10, dy: 5)
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField)
	{
		if (Theme.isMorning) { keyboardAppearance = .light } else { keyboardAppearance = .dark }
		let image = UIImage(named: "Navigation-Close")!

		let closeButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: image.size.width + 15, height: image.size.height - 1)))
		closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
		closeButton.setImage(image, for: .normal)
		closeButton.tintColor = Theme.colors[4]
		rightView = closeButton
		textAlignment = .left

		if let view = leftView { view.isHidden = true }

		if let placeholder = placeholder
		{
			let attributes = [.foregroundColor: Theme.colors[3], .font: Font.SearchBarTextFont] as [NSAttributedStringKey : Any]
			attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
		}
	}

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
	{
		if searchDelegate == nil, let delegate = UIApplication.shared.delegate as? AppDelegate, let navigationController = delegate.window?.rootViewController as? UINavigationController
		{
			let searchController = SearchViewController()
			searchDelegate = searchController
			navigationController.pushViewController(searchController, animated: true)
			return false
		} else { return true }
	}

	@objc func closeButtonTapped()
	{
		if (self.isEditing) { resignFirstResponder() } else
		{
			searchDelegate?.searchBarDidTappedCloseButton(self)
			close()
		}
	}

	func textFieldDidEndEditing(_ textField: UITextField)
	{
		if let text = text, !text.isEmpty { searchDelegate?.searchBarDidTappedSearchButton(self) } else
		{
			searchDelegate?.searchBarDidTappedCloseButton(self)
			close()
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		if let text = text, !text.isEmpty { resignFirstResponder() }
		return true
	}
}
