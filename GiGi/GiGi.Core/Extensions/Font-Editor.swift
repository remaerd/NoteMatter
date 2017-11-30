//
//  Font.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 18/11/2017.
//

import Foundation

extension Font
{
	public static var EditorRegularFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()
	
	public static var EditorItalicFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .italic, fontSize: size), size: size)!
	}()
	
	public static var EditorBoldFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader1Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .heavy, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader2Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader3Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
	
	public static var EditorHeader4Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
}
