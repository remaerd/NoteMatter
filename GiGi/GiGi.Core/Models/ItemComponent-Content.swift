//
//  ItemComponent-Content.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 31/07/2017.
//

import Foundation

extension ItemComponent
{
	public var attributedContent: NSAttributedString
	{
		let string = NSMutableAttributedString(string: content)
		string.setAttributes(ItemComponent.regularStyle, range: NSRange(location: 0, length: (content as NSString).length))
		string.setAttributes(self.componentType.style, range: NSRange(location: 0, length:  (content as NSString).length))
		return string
	}
}
