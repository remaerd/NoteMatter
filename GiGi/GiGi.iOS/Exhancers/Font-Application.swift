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
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()
	
	public static var CellDescriptionFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .semibold, fontSize: size), size: size)!
	}()
	
	public static var SolutionFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()
	
	public static var SearchBarTextFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .medium, fontSize: size), size: size)!
	}()
	
	public static var SearchBarButtonFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return UIFont(name: FontFamily.sanFranciscoUI.fontName(fontWeight: .medium, fontSize: size), size: size)!
	}()
	
	public static var TaskCellFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).pointSize
		return UIFont(name: FontFamily.sanFranciscoCompact.fontName(fontWeight: .semibold, fontSize: size), size: size)!
	}()
	
	public static var TaskHeaderFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title2).pointSize
		return UIFont(name: FontFamily.sanFranciscoCompact.fontName(fontWeight: .bold, fontSize: size), size: size)!
	}()
	
	public static var TaskDescriptionFont: UIFont =
	{
		let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize
		return UIFont(name: FontFamily.sanFranciscoCompact.fontName(fontWeight: .regular, fontSize: size), size: size)!
	}()
}
