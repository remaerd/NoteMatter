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
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .regular, size: size)
	}()
	
	public static var EditorItalicFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .italic, size: size)
	}()
	
	public static var EditorBoldFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .bold, size: size)
	}()
	
	public static var EditorHeader1Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .regular, size: size)
	}()
	
	public static var EditorHeader2Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .regular, size: size)
	}()
	
	public static var EditorHeader3Font: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .regular, size: size)
	}()
}
