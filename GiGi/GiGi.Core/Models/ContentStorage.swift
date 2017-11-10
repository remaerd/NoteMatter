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
	public let item: Item
	public var selectedRange: NSRange?
	
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
		self.item.cache()
		self.item.delegate = self
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

extension ContentStorage: ItemDelegate
{
	public func itemContentDidChanged(_ item: Item, range: NSRange)
	{
		
	}
}

// MARK: Override TextView Method
extension ContentStorage
{
	open override var string : String
	{
		return item.cachedComponents.string
	}
	
	open override func attributedSubstring(from range: NSRange) -> NSAttributedString
	{
		var stringRange = range
		if (range.location + range.length) >= item.cachedComponents.length { stringRange = NSRange(location: 0, length: item.cachedComponents.length) }
		return item.cachedComponents.attributedSubstring(from: stringRange)
	}
	
	public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any]
	{
		return item.cachedComponents.attributes(at: location, effectiveRange: range)
	}
	
	public override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange)
	{
		return item.cachedComponents.setAttributes(attrs, range: range)
	}
	
	open override func replaceCharacters(in range: NSRange, with str: String)
	{
		guard let result = item.replaceCachedComponents(range, with: str) else { return }
		beginEditing()
		edited([.editedCharacters, .editedAttributes], range: result.range, changeInLength: result.newLength)
		endEditing()
	}
	
	public override func processEditing()
	{
		if _requireUpdate == true { _requireUpdate = false }
		super.processEditing()
	}
}
