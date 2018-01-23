//
//  IconCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 09/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Cartography

class IconCell: UICollectionViewCell
{
	var iconView: UIImageView = UIImageView()
	var descriptionLabel: UILabel = UILabel()

	override init(frame: CGRect)
	{
		super.init(frame: frame)

		iconView.contentMode = .center
		iconView.layer.cornerRadius = Constants.bigButtonCornerRadius
		
		descriptionLabel.font = Font.TemplateFont
		descriptionLabel.textAlignment = .center
		descriptionLabel.textColor = Theme.colors[7]
		
		addSubview(descriptionLabel)
		addSubview(iconView)
		
		constrain(iconView)
		{ view in
			view.leading == view.superview!.leading
			view.top == view.superview!.top
			view.trailing == view.superview!.trailing
			view.height == Constants.bigButtonSize
		}
		
		constrain(descriptionLabel)
		{ view in
			view.bottom == view.superview!.bottom
			view.leading == view.superview!.leading
			view.trailing == view.superview!.trailing
			view.height == Constants.itemButtonDescriptionHeight
		}
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
