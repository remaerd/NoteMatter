//
//  ContentStorage.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

public class ContentStorage : NSTextStorage
{
	public let item: Item
	public var backingStore = NSMutableAttributedString()

	fileprivate var requireUpdate = false

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
extension ContentStorage
{
	open override var string : String
	{
		return backingStore.string
	}

	open override func attributedSubstring(from range: NSRange) -> NSAttributedString
	{
		var stringRange = range
		if (range.location + range.length) >= backingStore.length { stringRange = NSRange(location: 0, length: backingStore.length) }
		return backingStore.attributedSubstring(from: stringRange)
	}

	public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any]
	{
		return backingStore.attributes(at: location, effectiveRange: range)
	}

	open override func replaceCharacters(in range: NSRange, with str: String)
	{
		var string = str
		var stringRange = range
		autoFillRelativeCharacter(&string, range: &stringRange)
		beginEditing()
		backingStore.replaceCharacters(in: stringRange, with: string)
		let length = (string as NSString).length - stringRange.length
		edited([.editedCharacters, .editedAttributes], range: stringRange, changeInLength: length)
		requireUpdate = true
		endEditing()

		replaceItemComponents(range: stringRange, string: string)
	}

	public override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange)
	{
		beginEditing()
		backingStore.setAttributes(attrs, range: range)
		#if os(iOS)
			edited(.editedAttributes, range: range, changeInLength: 0)
		#else
			if #available(OSX 10.11, *) {
				let actions : NSTextStorageEditActions = [.EditedAttributes]
				edited(actions, range: range, changeInLength: 0)
			}
		#endif
		endEditing()
	}

	open override func processEditing()
	{
		func enumerateAutoDetectableText(_ range: NSRange)
		{
			dataDetector.enumerateMatches(in: backingStore.string, options: [], range: range)
			{
				(match, _, _) -> Void in
				if match != nil {
					switch match!.resultType
					{
					case NSTextCheckingResult.CheckingType.link: if let url = match!.url { addAttribute(NSAttributedStringKey.link, value: url, range: match!.range) }
					default: break
					}
				}
			}
		}

		if requireUpdate == true
		{
			requireUpdate = false
			let range = (backingStore.string as NSString).paragraphRange(for: editedRange)
			enumerateAutoDetectableText(range)
		}
		super.processEditing()
	}
}

public extension ContentStorage
{
	public func reload()
	{
		var currentIndex = 0
		backingStore = NSMutableAttributedString()

		for component: ItemComponent in item.components
		{
			let attributedContent = NSMutableAttributedString(string: component.content + "\n")
			currentIndex += (component.content as NSString).length
			for (range, style) in component.innerStyles
			{
				attributedContent.setAttributes(style.style, range: range)
			}
			backingStore.append(attributedContent)
		}
	}

	public func replaceItemComponents(range: NSRange, string: String)
	{
		Application.shared.database.beginWrite()

		var paragraphLocation = 0
		var paragraphIndex = 0
		let paragraphRange = (backingStore.string as NSString).paragraphRange(for: NSRange(location: range.location, length: 0))
		var paragraphString = (backingStore.string as NSString).substring(with: paragraphRange)
		paragraphString = paragraphString.replacingOccurrences(of: "\n", with: "")

		// 获得当前光标所在的段落 Index
		while range.location > paragraphLocation
		{
			print(paragraphIndex, item.components.count)
			if paragraphIndex >= item.components.count - 1 { break } else
			{
				paragraphLocation += (item.components[paragraphIndex].content as NSString).length
				print("\(range.location), \(paragraphLocation)")
				if (range.location > paragraphLocation) { paragraphIndex += 1 }
			}
		}

		print(paragraphIndex)

		let replacedString = (backingStore.string as NSString).substring(with: range)
		var createdComponents = (string.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false) as [Substring])
		var deletedComponents = (replacedString.split(separator: "\n", maxSplits: Int.max, omittingEmptySubsequences: false) as [Substring])

		if deletedComponents.count > 1
		{
			while deletedComponents.isEmpty
			{
				item.components.remove(objectAtIndex: paragraphIndex + 1)
				deletedComponents.removeFirst()
			}
		}

		if item.components.isEmpty
		{
			let component = ItemComponent(item: item, componentType: .body)
			component.content = String(createdComponents[0])
		}

		if createdComponents.count > 1
		{
			for i in 0..<createdComponents.count
			{
				if i == 0 {  } else
				{
					let index = paragraphIndex + i
					let component: ItemComponent
					if (index >= item.components.count) { component = ItemComponent(item: item, componentType: .body) } else { component = ItemComponent(item: item, componentType: .body, index: index) }
					component.content = String(createdComponents[i])
				}
			}
		}

		item.components[paragraphIndex].content = paragraphString

		print(item.components)

		do { try Application.shared.database.commitWrite() } catch { print("Error") }
	}
}
