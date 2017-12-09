//
//  ContentStorage-KeyboardBar.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 19/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

public extension ContentStorage
{
	public func setParagraphStyle(range: NSRange) -> NSRange
	{
		let paragraphRange = paragraphIndex(range: range)
		guard let components = ContentStorage.item?.components[paragraphRange.location..<paragraphRange.location + paragraphRange.length] else { return range }
//		for component in components { component.componentType = style }
		try! ContentStorage.item?.save()
		return range
	}
	
	public func toggleTask(range: NSRange) -> NSRange
	{
		return range
//		guard let range = selectedRange else { return }
//		guard let components = item.components(range: range) else { return }
//		Application.shared.database.beginWrite()
//		for component in components
//		{
//			var add = false
//			if let _ = components.first?.task { add = true }
//			if !add
//			{
//				guard let task = component.task else { break }
//				Application.shared.database.delete(task)
//			} else
//			{
//				if let _ = component.task { break }
//				let task = Task()
//				Application.shared.database.add(task)
//			}
//		}
//		try Application.shared.database.commitWrite()
	}
	
	public func setInlineStyle(range: NSRange) -> NSRange
	{
		return range
		//		guard let components = selectedComponents else { return }
		//		Application.shared.database.beginWrite()
	}
	
	public func setLink(range: NSRange, url: URL?) -> NSRange
	{
		return range
	}
	
	public func setBrace(range: NSRange) -> NSRange
	{
		replaceCharacters(in: range, with: "")
		return range
	}
	
	public func setSingleQuote(range: NSRange) -> NSRange
	{
		replaceCharacters(in: range, with:  "\'")
		return NSRange(location: range.location + 1, length: 0)
	}
	
	public func setPunctuation(range: NSRange) -> NSRange
	{
		replaceCharacters(in: range, with: "")
		return range
	}
}

