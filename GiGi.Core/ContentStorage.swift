//
//  ContentStorage.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

let regex = try! NSRegularExpression(pattern: "\n", options: NSRegularExpression.Options.caseInsensitive)

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

	public override init(attributedString attrStr: NSAttributedString)
	{
		self.backingStore = NSMutableAttributedString(attributedString: attrStr)
		item = Item()
		print(attrStr)
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
		let replacedString = (backingStore.string as NSString).substring(with: range)

		beginEditing()
		backingStore.replaceCharacters(in: stringRange, with: string)
		let length = (string as NSString).length - stringRange.length
		edited([.editedCharacters, .editedAttributes], range: stringRange, changeInLength: length)
		requireUpdate = true
		endEditing()

		replaceComponents(range: stringRange, replacedString: replacedString, newString: string)
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
			{ (match, _, _) -> Void in
				if match != nil
				{
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

		for i in 0..<item.components.count
		{
			let component = item.components[i]
			var content = component.content
			if i < item.components.count - 1 { content += "\n" }
			let attributedContent = NSMutableAttributedString(string: content)
			currentIndex += (component.content as NSString).length
			for (range, style) in component.innerStyles
			{
				attributedContent.setAttributes(style.style, range: range)
			}
			backingStore.append(attributedContent)
		}
	}

	func replaceComponents(range: NSRange, replacedString: String, newString: String)
	{
		Application.shared.database.beginWrite()
		let selectedParagraphIndex = currentParagraphIndex(range: range)
		let selectedParagraphRange = (backingStore.string as NSString).paragraphRange(for: NSRange(location: range.location, length: 0))
		let selectedParagraphString = (backingStore.string as NSString).substring(with: selectedParagraphRange).replacingOccurrences(of: "\n", with: "")

		// 当数据库中没有记录任何 Component 时，创建一个新的 Component
		if (item.components.isEmpty)
		{
			let component = ItemComponent(item: item, componentType: .body)
			component.content = newString
		}

		if range.length != 0
		{
			// 如果替换数据中没有换行，则只更新当前这行的数据
			if replacedString.contains("\n") == false { item.components[selectedParagraphIndex].content = selectedParagraphString } else
			{
				// 分析替换数据中存在多少次换行
				let deleteComponents = replacedString.split(separator: "\n")

				// 如果换了一次行，则删掉当前段落的下一个 Component
				if (deleteComponents.isEmpty) { Application.shared.database.delete(item.components[selectedParagraphIndex + 1]) } else
				{
					// 如果存在多次换行，则删掉当前段落接下之后的全部 Components
					for _ in deleteComponents { Application.shared.database.delete(item.components[selectedParagraphIndex + 1]) }
				}

				// 更新当前段落的 Component
				item.components[selectedParagraphIndex].content = selectedParagraphString
			}
		}

		if (newString as NSString).length != 0
		{
			// 如果新数据中没有换行，则只更新当前这行的数据
			if newString.contains("\n") == false { item.components[selectedParagraphIndex].content = selectedParagraphString } else
			{
				// 分析新数据中存在多少次换行
				let createComponents = newString.split(separator: "\n")

				// 段落开始
				if (range.location == selectedParagraphRange.location)
				{
					if (createComponents.isEmpty)
					{
						let component = ItemComponent(item: item, componentType: .body, index: selectedParagraphIndex)
						component.content = String("")
					} else
					{
						for i in 0..<createComponents.count
						{
							let component = ItemComponent(item: item, componentType: .body, index: selectedParagraphIndex + i)
							component.content = String(createComponents[i])
						}
					}
				} else
				{
					// 段落中间或结尾
					if (createComponents.isEmpty)
					{
						item.components[selectedParagraphIndex].content = selectedParagraphString

						let component = ItemComponent(item: item, componentType: .body, index: selectedParagraphIndex + 1)
						let nextParagraphRange = (backingStore.string as NSString).paragraphRange(for: NSRange(location: range.location + 1, length: 0))
						let nextParagraphString = (backingStore.string as NSString).substring(with: nextParagraphRange).replacingOccurrences(of: "\n", with: "")
						component.content = nextParagraphString
					} else
					{
						for i in 0..<createComponents.count
						{
							let index = selectedParagraphIndex + i
							let component: ItemComponent
							if (index >= item.components.count) { component = ItemComponent(item: item, componentType: .body) } else { component = ItemComponent(item: item, componentType: .body, index: index) }
							component.content = String(createComponents[i]).replacingOccurrences(of: "\n", with: "")
						}
					}
				}
			}
		}

		// 获得当前这行
		do { try Application.shared.database.commitWrite() } catch { print("Error") }
	}

	func currentParagraphIndex(range: NSRange) -> Int
	{
		var paragraphIndex = 0
		let matches = regex.matches(in: backingStore.string, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: (backingStore.string as NSString).length))
		for i in 0..<matches.count
		{
			let match = matches[i]
			if (match.range.location < range.location) { paragraphIndex += 1 } else { break }
		}
		return paragraphIndex
	}
}
