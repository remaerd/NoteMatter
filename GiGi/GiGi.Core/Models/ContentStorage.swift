//
//  ContentStorage.swift
//  TextEditor
//
//  Created by Sean Cheng on 2/12/2017.
//  Copyright © 2017 Sean Cheng. All rights reserved.
//

import UIKit

public class ContentStorage: NSTextStorage
{
	// WARNING: 由于 NSTextStorage 的设计问题。进行粘贴复制多行内容时，软件会尝试新建一个 NSTextStorage 并进行操作。
	// 为了防止软件崩溃，只能通过一种比较奇葩的方式设置 Item
	public static var item: Item?
	
	// 为了防止重复创建 CoreData 数据，将真正编辑中的 NSTextStorage 标为 editing，当不是编辑状态时，暂停进行 processChanges
	public var isEditing = false
	
	public let attributedString : NSMutableAttributedString
	public var componentsLength = [Int]()
	
	public override init()
	{
		let paragraph = NSMutableParagraphStyle()
		paragraph.lineSpacing = CGFloat(1.5)
		let style = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),
								 NSAttributedStringKey.paragraphStyle: paragraph]
		let attributedString = NSMutableAttributedString(string: "", attributes: style)
		
		if let components = ContentStorage.item?.components
		{
			for index in 0..<components.count
			{
				if let content = components[index].indexedContent
				{
					if index == 0 { attributedString.append(NSAttributedString(string: content, attributes: style)) }
					else { attributedString.append(NSAttributedString(string: "\n" + content, attributes: style)) }
					componentsLength.append(content.count)
				}
			}
		}
		
		self.attributedString = attributedString
		super.init()
	}
	
	public required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

extension ContentStorage
{
	public override var string: String
	{
		return attributedString.string
	}
	
	public override func attributedSubstring(from range: NSRange) -> NSAttributedString
	{
		return attributedString.attributedSubstring(from:range)
	}
	
	public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any]
	{
		return attributedString.attributes(at: location, effectiveRange: range)
	}
}

extension ContentStorage
{
	public override func replaceCharacters(in range: NSRange, with str: String)
	{
		if isEditing { processChanges(range: range, string: str) }
		edited([.editedCharacters, .editedAttributes], range: range, changeInLength: str.count - range.length)
		attributedString.replaceCharacters(in: range, with: str)
		endEditing()
	}
	
	public override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange)
	{
		beginEditing()
		edited(.editedAttributes, range: range, changeInLength: 0)
		attributedString.setAttributes(attrs, range: range)
		endEditing()
	}
}

// WARNING: 以下部分的内容是整个项目内比较难处理，逻辑最复杂的部分之一。任何情况下不要随意改动。
extension ContentStorage
{
	func processChanges(range: NSRange, string: String)
	{
		var currentParagraphIndex: Int = 0
		var currentParagraphLength: Int = 0
		for length in componentsLength
		{
			if range.location > currentParagraphLength + length
			{
				currentParagraphLength += length + 1
				currentParagraphIndex += 1
			}
			else { break }
		}
		
		var prevLine: String?
		let prevLineParagraphRange = (attributedString.string as NSString).paragraphRange(for: NSRange(location: range.location, length: 0))
		if prevLineParagraphRange.location <= range.location
		{
			let range = NSRange(location: prevLineParagraphRange.location, length: range.location - prevLineParagraphRange.location)
			prevLine = (attributedString.string as NSString).substring(with: range)
		}
		
		var nextLine: String?
		let nextLineParagraphRange = (attributedString.string as NSString).paragraphRange(for: NSRange(location: range.location + range.length, length: 0))
		if nextLineParagraphRange.location + nextLineParagraphRange.length > range.location + range.length
		{
			let location = range.location + range.length
			let length = nextLineParagraphRange.location + nextLineParagraphRange.length - range.location - range.length
			let range = NSRange(location: location, length: length)
			nextLine = (attributedString.string as NSString).substring(with: range)
			if nextLine?.hasSuffix("\n") == true { nextLine?.removeLast() }
		}

		if range.length != 0
		{
			let changedString = attributedString.attributedSubstring(from: range).string
			let changedContents = changedString.components(separatedBy: "\n")
			for index in 0..<changedContents.count
			{
				if index == 0
				{
					let component = ContentStorage.item?.components?[currentParagraphIndex]
					let content: String
					if changedContents.count > 1
					{
						if let newLine = nextLine { content = prevLine! + newLine }
						else { content = prevLine! }
					}
					else
					{
						content = (component!.indexedContent! as NSString).substring(to: component!.indexedContent!.count - changedContents[0].count )
					}
					component?.indexedContent = content
					componentsLength[currentParagraphIndex] = content.count
				}
				else
				{
					componentsLength.remove(at: currentParagraphIndex + 1)
					ContentStorage.item!.removeFromComponents(at: currentParagraphIndex + 1)
				}
			}
		}
		
		if !string.isEmpty
		{
			let newContents = string.components(separatedBy: "\n")
			for index in 0..<newContents.count
			{
				if componentsLength.count != 0 && index == 0
				{
					let component = ContentStorage.item!.components![currentParagraphIndex + index]
					let content: String
					if newContents.count > 1 { content = prevLine! + newContents[index] }
					else { content = component.indexedContent! + newContents[index] }
					componentsLength[currentParagraphIndex] = content.count
					component.indexedContent = content
				}
				else
				{
					var content = newContents[index]
					if index == newContents.count - 1, let newLine = nextLine { content += newLine }
					if currentParagraphIndex < componentsLength.count
					{
						componentsLength.insert(content.count, at: currentParagraphIndex + index)
						let component = try! ItemComponent.insert()
						component.type = ItemComponent.ComponentType.body.rawValue
						component.indexedContent = content
						ContentStorage.item?.insertIntoComponents(component, at: currentParagraphIndex + index)
					}
					else
					{
						componentsLength.append(content.count)
						let component = try! ItemComponent.insert()
						component.type = ItemComponent.ComponentType.body.rawValue
						component.indexedContent = content
						ContentStorage.item?.addToComponents(component)
					}
				}
			}
		}
	}
}

