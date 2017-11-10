//
//  ItemComponent.swift
//  GiGi
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import RealmSwift

public final class ItemComponent: Object
{
	static var regularStyle =
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
	
	public enum ComponentInnerStyle: String
	{
		case bold
		case italic
		case strikethrough
		case placeholder
		case inlineCode

		public var style: [NSAttributedStringKey: Any]
		{
			switch self
			{
			case .bold: return [NSAttributedStringKey.font: Theme.EditorBoldFont, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .italic: return [NSAttributedStringKey.font: Theme.EditorRegularFont, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .strikethrough: return [NSAttributedStringKey.font: Theme.EditorRegularFont, NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
			case .placeholder: return [NSAttributedStringKey.font: Theme.EditorRegularFont, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .inlineCode: return [NSAttributedStringKey.font: Theme.EditorRegularFont, NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
			}
		}
	}

	public enum ComponentType: String
	{
		case body = ".components.body"
		case header1 = ".components.header1"
		case header2 = ".components.header2"
		case header3 = ".components.header3"
		case unorderedListItem = ".components.unorderedList"
		case orderedListItem = ".components.orderedList"
		case quote = ".components.quote"

		public var style: [NSAttributedStringKey:Any]
		{
			switch self
			{
			case .body: return [NSAttributedStringKey.font: Theme.EditorRegularFont, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .header1: return [ NSAttributedStringKey.font: Theme.EditorHeader2Font, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .header2: return [ NSAttributedStringKey.font: Theme.EditorHeader3Font, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .header3: return [ NSAttributedStringKey.font: Theme.EditorHeader4Font, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .unorderedListItem: return [ NSAttributedStringKey.font: Theme.EditorRegularFont, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .orderedListItem: return [ NSAttributedStringKey.font: Theme.EditorRegularFont, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			case .quote: return [ NSAttributedStringKey.font: Theme.EditorHeader4Font, NSAttributedStringKey.foregroundColor: Theme.colors[6]]
			}
		}

		public var searchable : Bool
		{
			switch self
			{
			case .body: return true
			case .header1: return true
			case .header2: return true
			case .header3: return true
			case .orderedListItem: return true
			case .unorderedListItem: return true
			case .quote: return true
			}
		}
	}

	@objc public dynamic var identifier: String = ""

	@objc public dynamic var _componentType : String = ComponentType.body.rawValue

	// TODO: 实现“时光穿越”功能，记录内容的删除时间
	//	public dynamic var deactivated: Date?

	@objc public dynamic var indexedContent: String?

	@objc fileprivate dynamic var _unindexedContent: String?

	@objc private dynamic var _innerStyles: Data?

	public var innerStyles = [(range: NSRange, style: ComponentInnerStyle)]()

	public let item = LinkingObjects(fromType: Item.self, property: "components")

	public let task = LinkingObjects(fromType: Task.self, property: "itemComponent")

	public override class func primaryKey() -> String?
	{
		return "identifier"
	}

	public override class func indexedProperties() -> [String]
	{
		return ["indexedContent"]
	}

	public override class func  ignoredProperties() -> [String]
	{
		return ["content", "innerStyles", "componentType"]
	}

	public convenience init(item: Item, componentType: ComponentType = ComponentType.body, index: Int? = nil, identifier: String = NSUUID().uuidString)
	{
		self.init()
		self.identifier = identifier
		self.componentType = componentType
		if let at = index { item.components.insert(self, at: at) } else { item.components.append(self) }
	}
}

public extension ItemComponent
{
	public var componentType: ComponentType
	{
		get { if let type = ComponentType(rawValue: _componentType) { return type } else { return ComponentType.body } }
		set { _componentType = newValue.rawValue }
	}
	
	public var content: String
	{
		get { if let value = indexedContent, componentType.searchable == true { return value } else if let value = _unindexedContent, componentType.searchable == false { return value } else { return "" } }
		set(value) { if componentType.searchable == true { indexedContent = value } else { _unindexedContent = value } }
	}
}
