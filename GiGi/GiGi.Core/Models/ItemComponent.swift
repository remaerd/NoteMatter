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
	public static var database: Database { return Database.standard }
	
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
			case .bold: return [NSAttributedStringKey.font: EditorBoldFont, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .italic: return [NSAttributedStringKey.font: EditorRegularFont, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .strikethrough: return [NSAttributedStringKey.font: EditorRegularFont, NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
			case .placeholder: return [NSAttributedStringKey.font: EditorRegularFont, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .inlineCode: return [NSAttributedStringKey.font: EditorRegularFont, NSAttributedStringKey.strikethroughStyle: NSUnderlineStyle.styleSingle.rawValue]
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
			case .body: return [NSAttributedStringKey.font: Font.EditorRegularFont, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .header1: return [ NSAttributedStringKey.font: Font.EditorHeader2Font, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .header2: return [ NSAttributedStringKey.font: Font.EditorHeader3Font, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .header3: return [ NSAttributedStringKey.font: Font.EditorHeader4Font, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .unorderedListItem: return [ NSAttributedStringKey.font: Font.EditorRegularFont, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .orderedListItem: return [ NSAttributedStringKey.font: Font.EditorRegularFont, NSAttributedStringKey.foregroundColor: Application.themeColor]
			case .quote: return [ NSAttributedStringKey.font: Font.EditorHeader4Font, NSAttributedStringKey.foregroundColor: Application.themeColor]
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
	
	public var componentType: ComponentType
	{
		get
		{
			if let type = ComponentType(rawValue: self.type) { return type }
			else
			{
				type = ComponentType.body.rawValue
				return .body
			}
		}
		set { type = newValue.rawValue }
	}
}


public extension ItemComponent
{
	public static var EditorRegularFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: Font.FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()
	
	public static var EditorItalicFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: Font.FontFamily.sanFranciscoUI.fontName(fontWeight: .italic, fontSize: size), size: size)!
	}()
	
	public static var EditorBoldFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: Font.FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader1Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: Font.FontFamily.sanFranciscoUI.fontName(fontWeight: .heavy, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader2Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: Font.FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader3Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: Font.FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader4Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: Font.FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
}
