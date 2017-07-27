//
//  SearchBar.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

protocol SearchBarDelegate: NSObjectProtocol
{
	func searchBarDidChanged(_ searchBar: SearchBar, content: String)
	func searchBarDidTappedSearchButton(_ searchBar: SearchBar)
	func searchBarDidTappedCloseButton(_ searchBar: SearchBar)
}

class SearchBar: UITextField
{
	var rightButton: UIButton?

	weak var searchDelegate: SearchBarDelegate?

	var navigationItem: UINavigationItem?
	{
		didSet { setBarButtons() }
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
		returnKeyType = .continue
		enablesReturnKeyAutomatically = true
		layer.cornerRadius = Constants.defaultCornerRadius
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func willMove(toWindow newWindow: UIWindow?)
	{
		super.willMove(toWindow: newWindow)
		NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChanged(notification:)), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
	}

	@objc func textViewDidChanged(notification: NSNotification)
	{
		var string = ""
		if let text = text { string = text }
		searchDelegate?.searchBarDidChanged(self, content: string)
	}

	override func textRect(forBounds bounds: CGRect) -> CGRect
	{
		return bounds.insetBy(dx: 10, dy: 5)
	}

	override func editingRect(forBounds bounds: CGRect) -> CGRect
	{
		return bounds.insetBy(dx: 10, dy: 5)
	}

	func placeholderDidChanged()
	{
		if let placeholder = placeholder
		{
			attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: Theme.colors[6], NSAttributedStringKey.font: Theme.SearchBarTextFont])
		}
	}

	func setBarButtons()
	{
		func barButton(item: UIBarButtonItem) -> UIButton
		{
			let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: item.image!.size.width + 15, height: item.image!.size.height - 1)))
			button.tintColor = Theme.colors[5]
			button.setImage(item.image!, for: .normal)
			button.addTarget(item.target!, action: item.action!, for: .touchUpInside)
			return button
		}

		if let items = navigationItem?.leftBarButtonItems { leftView = barButton(item: items[0]) } else { leftView = UIView() }
		if let items = navigationItem?.rightBarButtonItems { rightView = barButton(item: items[0]) } else { rightView = UIView() }
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
	func textFieldDidBeginEditing(_ textField: UITextField)
	{
		if (Theme.isMorning) { keyboardAppearance = .light } else { keyboardAppearance = .dark }
		let image = UIImage(named: "Navigation-Close")!

		let closeButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: image.size.width + 15, height: image.size.height - 1)))
		closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
		closeButton.setImage(image, for: .normal)
		closeButton.tintColor = Theme.colors[5]
		rightView = closeButton
		textAlignment = .left

		if let view = leftView { view.isHidden = true }

		if let placeholder = placeholder
		{
			let attributes = [NSAttributedStringKey.foregroundColor: Theme.colors[3], NSAttributedStringKey.font: Theme.SearchBarTextFont] as [NSAttributedStringKey : Any]
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
