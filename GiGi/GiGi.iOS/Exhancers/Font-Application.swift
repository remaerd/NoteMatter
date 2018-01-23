//
//  Font.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 18/11/2017.
//

import UIKit

extension Font
{
	public static var CellFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .regular, size: size)
	}()
	
	public static var CellDescriptionFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .semibold, size: size)
	}()
	
	public static var TemplateFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .regular, size: size)
	}()
	
	public static var SegmentBarFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .bold, size: size)
	}()
	
	public static var SearchBarTextFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return FontFamily.sanFrancisco.fontName(type: .compact, weight: .semibold, size: size)
	}()
	
	public static var SearchBarButtonFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return FontFamily.sanFrancisco.fontName(type: .regular, weight: .medium, size: size)
	}()
	
	public static var TaskCellFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return FontFamily.sanFrancisco.fontName(type: .compact, weight: .semibold, size: size)
	}()
	
	public static var TaskHeaderFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).pointSize
		return FontFamily.sanFrancisco.fontName(type: .compact, weight: .bold, size: size)
	}()
	
	public static var TaskDescriptionFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return FontFamily.sanFrancisco.fontName(type: .compact, weight: .regular, size: size)
	}()
}
