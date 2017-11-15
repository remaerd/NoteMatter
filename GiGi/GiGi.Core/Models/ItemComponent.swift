//
//  ItemComponent.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 14/11/2017.
//
//

import Foundation
import CoreData

@objc(ItemComponent)
public class ItemComponent: NSManagedObject, Model
{
	public static var database: Database { return Database.defaultDatabase }
	
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
}
