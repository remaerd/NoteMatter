//
//  SwitchCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 16/11/2017.
//

import UIKit

class SwitchCell: Cell
{
	let switcher = UISwitch()
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		self.addSubview(switcher)
		switcher.translatesAutoresizingMaskIntoConstraints = false
		switcher.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.edgeMargin).isActive = true
		switcher.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		switcher.onTintColor = Theme.colors[8]
		switcher.tintColor = Theme.colors[7].withAlphaComponent(0.2)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
