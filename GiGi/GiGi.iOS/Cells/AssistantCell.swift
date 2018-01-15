//
//  AssistantCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 1/12/2017.
//

import GiGi
import UIKit
import Cartography

class AssistantCell: UICollectionViewCell
{
	lazy var titleLabel = UILabel()
	lazy var instructionLabel = UILabel()
	lazy var button = UIButton()
	
	func reloadItem(item: Item)
	{
		for subview in subviews
		{
			subview.removeFromSuperview()
		}
		
		addSubview(titleLabel)
		addSubview(instructionLabel)
		addSubview(button)
		constrain(titleLabel, instructionLabel, button)
		{
			title, instruction, button in

			title.centerX == title.superview!.centerX
			title.centerY == title.superview!.centerY - 40
			instruction.centerX == instruction.superview!.centerX
			instruction.top == title.bottom
			button.centerX == button.superview!.centerX
			button.top == instruction.bottom
		}
	}
	
	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
	{
		var newFrame = layoutAttributes.frame
		newFrame.size = contentView.systemLayoutSizeFitting(layoutAttributes.size, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
		layoutAttributes.frame = newFrame
		return layoutAttributes
	}
}
