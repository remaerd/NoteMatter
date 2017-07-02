//
//  SearchBar.swift
//  GiGi
//
//  Created by Sean Cheng on 29/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class SearchBar: UITextField
{
	var rightButton: UIButton?

	override init(frame: CGRect)
	{
		super.init(frame: frame)
		layer.cornerRadius = Constants.defaultCornerRadius
		textAlignment = .center
		returnKeyType = .search
		delegate = self
		rightViewMode = .always
		leftViewMode = .always
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func willMove(toWindow newWindow: UIWindow?)
	{
		super.willMove(toWindow: newWindow)
		backgroundColor = Theme.colors[0]
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
		let image = UIImage(named: "Navigation-Close")!
		let closeButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: image.size.width + 15, height: image.size.height - 1)))
		closeButton.tintColor = Theme.colors[5]
		closeButton.setImage(image, for: .normal)
		closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
		rightView = closeButton
		textAlignment = .left
		if let view = leftView { view.isHidden = true }
	}

	func closeButtonTapped()
	{
		resignFirstResponder()
	}

	func textFieldDidEndEditing(_ textField: UITextField)
	{
		if let view = leftView { view.isHidden = false }
		rightView = rightButton
		text = nil
		textAlignment = .center
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		return true
	}
}
