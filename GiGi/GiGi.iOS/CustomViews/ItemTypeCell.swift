//
//  ItemTypeCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 09/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell
{
	var iconView: UIImageView = UIImageView()
	var descriptionLabel: UILabel = UILabel()

	override init(frame: CGRect)
	{
		super.init(frame: frame)

		addSubview(descriptionLabel)
		addSubview(iconView)

		iconView.translatesAutoresizingMaskIntoConstraints = false
		iconView.contentMode = .center
		iconView.layer.cornerRadius = Constants.bigButtonCornerRadius
		iconView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		iconView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		iconView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		iconView.heightAnchor.constraint(equalToConstant: Constants.bigButtonSize).isActive = true

		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		descriptionLabel.font = Font.SolutionFont
		descriptionLabel.numberOfLines = 2
		descriptionLabel.textAlignment = .center
		descriptionLabel.textColor = Theme.colors[7]
		descriptionLabel.heightAnchor.constraint(equalToConstant: Constants.itemButtonDescriptionHeight).isActive = true
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
