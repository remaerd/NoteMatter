//
//  UICollectionViewController-Dragable.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 08/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

extension UICollectionViewController
{
	func addDragableButton() -> DragableButton
	{
		let addButton = DragableButton()
		view.addSubview(addButton)
		addButton.translatesAutoresizingMaskIntoConstraints = false
		addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.bigButtonBottomMargin).isActive = true
		addButton.widthAnchor.constraint(equalToConstant: Constants.bigButtonSize).isActive = true
		addButton.heightAnchor.constraint(equalToConstant: Constants.bigButtonSize).isActive = true
		return addButton
	}
}
