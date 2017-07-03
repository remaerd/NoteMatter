//
//  SyntaxHighlightTextStorage.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

public class SyntaxRenderer : NSTextStorage
{
	public let item: Item
	public let attributedString = NSMutableAttributedString()

	fileprivate var requireUpdate = false

	lazy var autofillCharacters = ["(":")","[":"]","{":"}","（":"）","［":"］","｛":"｝","\"":"\"","“":"”","‘":"’","「":"」","《":"》","【":"】"]
	lazy var cjkCharacters      = [".":"。",",":"，",":":"：",";":"；","!":"！","?":"？","(":"（",")":"）","[":"［","]":"］","{":"｛","}":"｝"]

	lazy var regularStyle =
	{
		let style = NSMutableParagraphStyle()
		style.minimumLineHeight = 26
		style.maximumLineHeight = 26
		return [
			NSAttributedStringKey.paragraphStyle: Theme.EditorRegularFont,
			NSAttributedStringKey.foregroundColor: Theme.colors[6],
			NSAttributedStringKey.font: style
		]
	}() as [NSAttributedStringKey : Any]

	lazy var dataDetector : NSDataDetector =
	{
		var error: NSError?
		let types : NSTextCheckingResult.CheckingType = [.link, .phoneNumber, .address, .transitInformation]
		let detector = try! NSDataDetector(types: types.rawValue)
		return detector
	}()

	public init(item:Item)
	{
		self.item = item
		super.init()
		reload()
	}

	public required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	public required init(itemProviderData data: Data, typeIdentifier: String) throws
	{
		fatalError("init(itemProviderData:typeIdentifier:) has not been implemented")
	}
}

// MARK: Override TextView Method
extension SyntaxRenderer
{
	open override var string : String
	{
		return self.attributedString.string
	}

	open override func attributedSubstring(from range: NSRange) -> NSAttributedString
	{
		var stringRange = range
		if (range.location + range.length) >= self.attributedString.length { stringRange = NSRange(location: 0, length: self.attributedString.length) }
		return self.attributedString.attributedSubstring(from: stringRange)
	}

	public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any]
	{
		return attributedString.attributes(at: location, effectiveRange: range)
	}

	open override func replaceCharacters(in range: NSRange, with str: String)
	{
		var string = str
		var stringRange = range
		self.autoFillRelativeCharacter(&string, range: &stringRange)
		self.beginEditing()
		self.attributedString.replaceCharacters(in: stringRange, with: string)

		#if os(iOS)
			let length = (string as NSString).length - stringRange.length
			self.edited([.editedCharacters, .editedAttributes], range: stringRange, changeInLength: length)
		#else
			if #available(OSX 10.11, *) {
				let actions : NSTextStorageEditActions = [.EditedAttributes, .EditedCharacters]
				self.edited(actions, range: range, changeInLength: length)
			} else {
			}
		#endif

		self.requireUpdate = true
		self.endEditing()
	}

	public override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange)
	{
		self.beginEditing()
		self.attributedString.setAttributes(attrs, range: range)
		#if os(iOS)
			self.edited(.editedAttributes, range: range, changeInLength: 0)
		#else
			if #available(OSX 10.11, *) {
				let actions : NSTextStorageEditActions = [.EditedAttributes]
				self.edited(actions, range: range, changeInLength: 0)
			}
		#endif
		self.endEditing()
	}

	open override func processEditing()
	{
		func enumerateAutoDetectableText(_ range: NSRange)
		{
			self.dataDetector.enumerateMatches(in: self.attributedString.string, options: [], range: range)
			{
				(match, _, _) -> Void in
				if match != nil {
					switch match!.resultType
					{
					case NSTextCheckingResult.CheckingType.link: if let url = match!.url { self.addAttribute(NSAttributedStringKey.link, value: url, range: match!.range) }
					default: break
					}
				}
			}
		}

		if self.requireUpdate == true
		{
			self.requireUpdate = false
			let range = (self.attributedString.string as NSString).paragraphRange(for: self.editedRange)
			enumerateAutoDetectableText(range)
		}
		super.processEditing()
	}
}

public extension SyntaxRenderer
{
	public func reload()
	{
		let result = NSMutableAttributedString()
		for component: ItemComponent in item.components
		{
			guard let content = component.content else { return }
			let attributedContent = NSMutableAttributedString(string: content)
			for (range, style) in component.innerStyles
			{
				attributedContent.setAttributes(style.style, range: range)
			}
			result.append(attributedContent)
		}
	}
}

fileprivate extension SyntaxRenderer
{
	fileprivate func autoFillRelativeCharacter(_ string:inout String, range: inout NSRange)
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
				if removeCharacterRange.location < self.attributedString.length
				{
					let targetString = self.attributedString.attributedSubstring(from: removeCharacterRange).string
					if targetString == autoFilledCharacter { return true }
				}
			}
			return false
		}

		if range.length == 1
		{
			// If you are deleting a character. str property is empty. We need to get it from the attributedString
			let prevString = self.attributedSubstring(from: range)
			if removeRelativeCharacter(prevString, range: range) == true { range.length += 1 }
		} else if let insertString = insertRelativeCharacter(string, range: range) { string = "\(string)\(insertString)" }
	}
}
