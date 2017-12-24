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
	public func setParagraphStyle(range: NSRange) -> (index: Int, newRange: NSRange)
	{
		let paragraphRange = paragraphIndex(range: range)
		let components = ContentStorage.item!.components[paragraphRange.location..<paragraphRange.location + paragraphRange.length]
		let firstComponentType = components.first!.componentType
		let type: ItemComponent.ComponentType
		let newIndex: Int
		switch firstComponentType
		{
		case .body: type = .header1; newIndex = 2; break
		case .header1: type = .header2; newIndex = 3; break
		case .header2: type = .header3; newIndex = 4; break
		case .header3: type = .unorderedListItem; newIndex = 5; break
		case .unorderedListItem: type = .orderedListItem; newIndex = 6; break
		case .orderedListItem: type = .quote; newIndex = 7; break
		case .quote: type = .body; newIndex = 1; break
		}
		for component in components { component.componentType = type }
		try! ContentStorage.item?.save()
		return (index: newIndex, newRange: range)
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
	
	public func setBrace(range: NSRange) -> (index: Int, newRange: NSRange)
	{
		func replace(brace: String, replace: Bool)
		{
			var _range = range
			let content: String
			if replace { _range = NSRange(location: range.location - 1, length: range.length + 2) }
			if _range.length == 0 { content = punucations[brace]! + punucations[("!" + brace)]! }
			else { content = punucations[brace]! + (attributedString.string as NSString).substring(with: range) + punucations[("!" + brace)]! }
			replaceCharacters(in: _range, with: content)
		}
		
		if (range.location + range.length) >= attributedString.length
		{
			replace(brace: "\"", replace: false)
			return (1, NSRange(location: range.location + 1, length: range.length))
		}
		else
		{
			let existedRange = NSRange(location: range.location - 1, length: range.length + 2)
			let currentString = (self.string as NSString).substring(with: existedRange)
			if currentString.hasPrefix(punucations["\""]!) && currentString.hasSuffix(punucations["!\""]!)
			{
				replace(brace: "(", replace: true)
				return (2, range)
			}
			else if currentString.hasPrefix(punucations["("]!) && currentString.hasSuffix(punucations["!("]!)
			{
				replace(brace: "[", replace: true)
				return (3, range)
			}
			else if currentString.hasPrefix(punucations["["]!) && currentString.hasSuffix(punucations["!["]!)
			{
				replace(brace: "{", replace: true)
				return (4, range)
			}
			else if currentString.hasPrefix(punucations["{"]!) && currentString.hasSuffix(punucations["!{"]!)
			{
				replaceCharacters(in: NSRange(location: range.location + range.length, length: 1), with: "")
				replaceCharacters(in: NSRange(location: range.location - 1, length: 1), with: "")
				return (0, NSRange(location: range.location - 1, length: range.length))
			}
			else
			{
				replace(brace: "\"", replace: false)
				return (1, NSRange(location: range.location + 1, length: range.length))
			}
		}
	}
	
	public func setSingleQuote(range: NSRange) -> NSRange
	{
		replaceCharacters(in: range, with:  "\'")
		return NSRange(location: range.location + 1, length: 0)
	}
	
	public func setPunctuation(range: NSRange) -> (index: Int, newRange: NSRange)
	{
		let existedRange = NSRange(location: range.location - 2, length: 2)
		let previousPunucation = (self.string as NSString).substring(with: existedRange)
		switch previousPunucation
		{
		case punucations[","]! + " ":
			replaceCharacters(in: existedRange, with: punucations["."]! + " ")
			return (2, range)
		case punucations["."]! + " ":
			replaceCharacters(in: existedRange, with: punucations["!"]! + " ")
			return (3, range)
		case punucations["!"]! + " ":
			replaceCharacters(in: existedRange, with: punucations["?"]! + " ")
			return (4, range)
		case punucations["?"]! + " ":
			replaceCharacters(in: existedRange, with: "")
			return (0, NSRange(location: range.location - 2, length: 0))
		default:
			replaceCharacters(in: range, with: punucations[","]! + " ")
			return (1, NSRange(location: range.location + 2, length: 0))
		}
	}
}

