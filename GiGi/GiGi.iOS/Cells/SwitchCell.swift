//
//  SwitchCell.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 16/11/2017.
//

import UIKit
import Cartography

class SwitchCell: Cell
{
	let switcher = UISwitch()
	
	override init(frame: CGRect)
	{
		super.init(frame: frame)
		switcher.onTintColor = Theme.colors[8]
		switcher.tintColor = Theme.colors[2]
		switcher.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
		rightView = switcher
	}
	
	override func prepareForReuse()
	{
		switcher.isOn = false
		return
	}
	
	@objc func didTapped()
	{
		if switcher.isOn { Sound.switchOn.play() } else { Sound.switchOff.play() }
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
