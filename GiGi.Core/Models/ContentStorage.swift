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
	fileprivate var _requireUpdate = false
	//	fileprivate var _notificationToken: NotificationToken?
	
	public let item: Item
	public var backingStore = NSMutableAttributedString()
	public var selectedRange: NSRange?
	
	public var selectedParagraphRange: NSRange?
	{
		get
		{
			guard let range = selectedRange else { return nil }
			var paragraphRange = NSRange()
			let matches = regex.matches(in: backingStore.string, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: (backingStore.string as NSString).length))
			for i in 0..<matches.count
			{
				let match = matches[i]
				if (match.range.location < range.location) { paragraphRange.location += 1 } else if (match.range.location < range.location + range.length) { paragraphRange.length += 1 } else
				{
					paragraphRange.length += 1
					break
				}
			}
			return paragraphRange
		}
	}
	
	public var selectedComponents: [ItemComponent]?
	{
		get
		{
			var components = [ItemComponent]()
			guard let range = selectedParagraphRange else { return nil }
			for i in range.location..<range.location + range.length { components.append(item.components[i]) }
			print(components)
			return components
		}
	}
	
	lazy var regularStyle =
		{
			let style = NSMutableParagraphStyle()
			style.minimumLineHeight = 26
			style.maximumLineHeight = 26
			return [
				NSAttributedStringKey.paragraphStyle: style,
				NSAttributedStringKey.foregroundColor: Theme.colors[6],
				NSAttributedStringKey.font: Theme.EditorRegularFont
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
		//		self._notificationToken = item.addNotificationBlock
		//		{ (changed) in
		//			self.objectDidChanged(changed: changed)
		//		}
		reload()
	}
	
	public override init(attributedString attrStr: NSAttributedString)
	{
		self.backingStore = NSMutableAttributedString(attributedString: attrStr)
		item = Item()
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
		_requireUpdate = true
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
				if let match = match
				{
					switch match.resultType
					{
					case NSTextCheckingResult.CheckingType.link: if let url = match.url { addAttribute(NSAttributedStringKey.link, value: url, range: match.range) }
					default: break
					}
				}
			}
		}
		
		if _requireUpdate == true
		{
			_requireUpdate = false
			let range = (backingStore.string as NSString).paragraphRange(for: editedRange)
			enumerateAutoDetectableText(range)
		}
		super.processEditing()
	}
}

public extension ContentStorage
{
	//	func objectDidChanged(changed: ObjectChange)
	//	{
	//
	//	}
}

public extension ContentStorage
{
	public func reload()
	{
		backingStore = NSMutableAttributedString()
		for i in 0..<item.components.count
		{
			let component = item.components[i]
			var lastComponent = true
			if i < item.components.count - 1 { lastComponent = false }
			let attributedContent = renderComponent(component: component, lastComponent: lastComponent)
			backingStore.append(attributedContent)
		}
	}
	
	func renderComponent(component: ItemComponent, lastComponent: Bool = false) -> NSAttributedString
	{
		var content = component.content
		if !lastComponent { content += "\n" }
		let attributedContent = NSMutableAttributedString(string: content, attributes: regularStyle)
		for (range, innerStyle) in component.innerStyles { attributedContent.addAttributes(innerStyle.style, range: range) }
		return attributedContent
	}
	
	func replaceComponents(range: NSRange, replacedString: String, newString: String)
	{
		Application.shared.database.beginWrite()
		guard let paragraphIndex = selectedParagraphRange?.location else { return }
		let paragraphRange = (backingStore.string as NSString).paragraphRange(for: NSRange(location: range.location, length: 0))
		let paragraphString = (backingStore.string as NSString).substring(with: paragraphRange).replacingOccurrences(of: "\n", with: "")
		
		// 当数据库中没有记录任何 Component 时，创建一个新的 Component
		if (item.components.isEmpty) { ItemComponent(item: item, componentType: .body).content = newString }
		
		if range.length != 0
		{
			// 如果替换数据中没有换行，则只更新当前这行的数据
			if replacedString.contains("\n") == false { item.components[paragraphIndex].content = paragraphString } else
			{
				// 分析替换数据中存在多少次换行
				let deleteComponents = replacedString.split(separator: "\n")
				
				// 如果换了一次行，则删掉当前段落的下一个 Component
				if (deleteComponents.isEmpty) { Application.shared.database.delete(item.components[paragraphIndex + 1]) } else
				{
					// 如果存在多次换行，则删掉当前段落接下之后的全部 Components
					for _ in deleteComponents { Application.shared.database.delete(item.components[paragraphIndex + 1]) }
				}
				// 更新当前段落的 Component
				item.components[paragraphIndex].content = paragraphString
			}
		}
		
		if (newString as NSString).length != 0
		{
			// 如果新数据中没有换行，则只更新当前这行的数据
			if newString.contains("\n") == false { item.components[paragraphIndex].content = paragraphString } else
			{
				// 分析新数据中存在多少次换行
				let createComponents = newString.split(separator: "\n")
				
				// 段落开始
				if (range.location == paragraphRange.location)
				{
					if (createComponents.isEmpty) { ItemComponent(item: item, componentType: .body, index: paragraphIndex).content = String("") } else
					{
						for i in 0..<createComponents.count { ItemComponent(item: item, componentType: .body, index: paragraphIndex + i).content = String(createComponents[i]) }
					}
				} else
				{
					// 段落中间或结尾
					if (createComponents.isEmpty)
					{
						item.components[paragraphIndex].content = paragraphString
						let component = ItemComponent(item: item, componentType: .body, index: paragraphIndex + 1)
						let nextParagraphRange = (backingStore.string as NSString).paragraphRange(for: NSRange(location: range.location + 1, length: 0))
						let nextParagraphString = (backingStore.string as NSString).substring(with: nextParagraphRange).replacingOccurrences(of: "\n", with: "")
						component.content = nextParagraphString
					} else
					{
						for i in 0..<createComponents.count
						{
							let index = paragraphIndex + i
							let component: ItemComponent
							if (index >= item.components.count) { component = ItemComponent(item: item, componentType: .body) } else { component = ItemComponent(item: item, componentType: .body, index: index) }
							component.content = String(createComponents[i]).replacingOccurrences(of: "\n", with: "")
						}
					}
				}
			}
		}
		do { try Application.shared.database.commitWrite() } catch { print("Error") }
	}
}

