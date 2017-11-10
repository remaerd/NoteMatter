//
//  Item-Cache.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 31/07/2017.
//

import Foundation

fileprivate var autofillCharacters = ["(":")","[":"]","{":"}","（":"）","［":"］","｛":"｝","\"":"\"","“":"”","‘":"’","「":"」","《":"》","【":"】"]
fileprivate var cjkCharacters      = [".":"。",",":"，",":":"：",";":"；","!":"！","?":"？","(":"（",")":"）","[":"［","]":"］","{":"｛","}":"｝"]

extension Item
{
	public func paragraphRange(range: NSRange, changes: Int = 0) -> NSRange?
	{
		var paragraphRange = NSRange()
		var currentLocation = 0
		for component in components
		{
			let length = component.content.lengthOfBytes(using: .utf8)
			if (range.location > currentLocation) { paragraphRange.location += 1 }
			currentLocation += length
		}
		paragraphRange.location += (changes)
		if (paragraphRange.location < 0) { paragraphRange.location = 0 }
		return paragraphRange
	}
	
	public func components(range: NSRange) -> [ItemComponent]?
	{
		var components = [ItemComponent]()
		guard let range = paragraphRange(range: range) else { return nil }
		for i in range.location..<range.location + range.length { components.append(components[i]) }
		return components
	}
	
	public func cache()
	{
		cachedComponents = NSTextStorage()
		for i in 0..<components.count
		{
			let component = components[i]
			cachedComponents.append(component.attributedContent)
			if i < components.count - 1 { cachedComponents.append(NSAttributedString(string: "\n")) }
		}
		self.notificationToken = self.observe({ (changes) in
			let range = NSRange()
			self.delegate?.itemContentDidChanged(self, range: range)
		})
	}
	
	public func clearCache()
	{
		if let token = self.notificationToken { token.invalidate() }
		cachedComponents = NSTextStorage()
	}
	
	internal func replaceCachedComponents(_ range: NSRange, with str: String) -> (range: NSRange, newLength: Int)?
	{
		var string = str
		var range = range
		
		autoFillRelativeCharacter(&string, range: &range)
		
		let finalLength = -range.length + str.count
		let replacedString = (cachedComponents.string as NSString).substring(with: range)
		
		cachedComponents.replaceCharacters(in: range, with: str)
		
		Application.shared.database.beginWrite()
		
		let paragraphRange = (cachedComponents.string as NSString).paragraphRange(for: NSRange(location: range.location, length: 0))
		let paragraphString = (cachedComponents.string as NSString).substring(with: paragraphRange).replacingOccurrences(of: "\n", with: "")
		
		var changes = -1
		if (replacedString.contains("\n")) { for _ in replacedString.split(separator: "\n") { changes -= 1 }}
		guard let paragraphIndex = self.paragraphRange(range: range, changes: changes)?.location else { return nil }
		
		// 当数据库中没有记录任何 Component 时，创建一个新的 Component
		if (components.isEmpty) { ItemComponent(item: self, componentType: .body).content = str }
		
		if range.length != 0
		{
			// 如果替换数据中没有换行，则只更新当前这行的数据
			if replacedString.contains("\n") == false { components[paragraphIndex].content = paragraphString } else
			{
				// 分析替换数据中存在多少次换行
				let deleteComponents = replacedString.split(separator: "\n")
				
				// 如果换了一次行，则删掉当前段落的下一个 Component
				if (deleteComponents.isEmpty) { Application.shared.database.delete(components[paragraphIndex + 1]) } else
				{
					// 如果存在多次换行，则删掉当前段落接下之后的全部 Components
					for _ in deleteComponents { Application.shared.database.delete(components[paragraphIndex + 1]) }
				}
				// 更新当前段落的 Component
				components[paragraphIndex].content = paragraphString
			}
		}
		
		if (str as NSString).length != 0
		{
			// 如果新数据中没有换行，则只更新当前这行的数据
			if str.contains("\n") == false { components[paragraphIndex].content = paragraphString }
			else {
				// 分析新数据中存在多少次换行
				let createComponents = str.split(separator: "\n")
				
				// 段落开始
				if (range.location == paragraphRange.location)
				{
					if (createComponents.isEmpty) { ItemComponent(item: self, componentType: .body, index: paragraphIndex).content = String("") } else
					{
						for i in 0..<createComponents.count { ItemComponent(item: self, componentType: .body, index: paragraphIndex + i).content = String(createComponents[i]) }
					}
				} else
				{
					// 段落中间或结尾
					if (createComponents.isEmpty)
					{
						components[paragraphIndex].content = paragraphString
						let component = ItemComponent(item: self, componentType: .body, index: paragraphIndex + 1)
						let nextParagraphRange = (cachedComponents.string as NSString).paragraphRange(for: NSRange(location: range.location + 1, length: 0))
						let nextParagraphString = (cachedComponents.string as NSString).substring(with: nextParagraphRange).replacingOccurrences(of: "\n", with: "")
						component.content = nextParagraphString
					} else
					{
						for i in 0..<createComponents.count
						{
							let index = paragraphIndex + i
							let component: ItemComponent
							if (index >= components.count) { component = ItemComponent(item: self, componentType: .body) } else { component = ItemComponent(item: self, componentType: .body, index: index) }
							component.content = String(createComponents[i]).replacingOccurrences(of: "\n", with: "")
						}
					}
				}
			}
		}
		do { try Application.shared.database.commitWrite() } catch { print("Error") }
		return (range: range, newLength: finalLength)
	}
	
	internal func autoFillRelativeCharacter(_ string:inout String, range: inout NSRange)
	{
		func insertRelativeCharacter(_ string:String, range: NSRange) -> String?
		{
			if let autoFillCharacter = autofillCharacters[string] { return autoFillCharacter }
			return nil
		}
		
		func removeRelativeCharacter(_ prevString: NSAttributedString, range: NSRange) -> Bool
		{
			if let autoFilledCharacter = autofillCharacters[prevString.string]
			{
				var removeCharacterRange = range
				removeCharacterRange.location += 1
				if removeCharacterRange.location < cachedComponents.length
				{
					let targetString = cachedComponents.attributedSubstring(from: removeCharacterRange).string
					if targetString == autoFilledCharacter { return true }
				}
			}
			return false
		}
		
		if range.length == 1
		{
			// If you are deleting a character. str property is empty. We need to get it from the attributedString
			let prevString = cachedComponents.attributedSubstring(from: range)
			if removeRelativeCharacter(prevString, range: range) == true { range.length += 1 }
		} else if let insertString = insertRelativeCharacter(string, range: range) { string = "\(string)\(insertString)" }
	}
}
