//
//  ContentStorage-Autofill.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 04/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

fileprivate var autofillCharacters = ["(":")","[":"]","{":"}","（":"）","［":"］","｛":"｝","\"":"\"","“":"”","‘":"’","「":"」","《":"》","【":"】"]
fileprivate var cjkCharacters      = [".":"。",",":"，",":":"：",";":"；","!":"！","?":"？","(":"（",")":"）","[":"［","]":"］","{":"｛","}":"｝"]

internal extension ContentStorage
{
	internal func autoFillRelativeCharacter(_ string:inout String, range: inout NSRange)
	{
		func insertRelativeCharacter(_ string:String, range: NSRange) -> String?
		{
			if let autoFillCharacter = autofillCharacters[string] { return autoFillCharacter }
			return nil
		}

		func removeRelativeCharacter(_ prevString: NSAttributedString, range: NSRange) -> Bool
		{
			if let autoFilledCharacter = autofillCharacters[prevString.string]
			{
				var removeCharacterRange = range
				removeCharacterRange.location += 1
				if removeCharacterRange.location < self.backingStore.length
				{
					let targetString = self.backingStore.attributedSubstring(from: removeCharacterRange).string
					if targetString == autoFilledCharacter { return true }
				}
			}
			return false
		}

		if range.length == 1
		{
			// If you are deleting a character. str property is empty. We need to get it from the attributedString
			let prevString = self.attributedSubstring(from: range)
			if removeRelativeCharacter(prevString, range: range) == true { range.length += 1 }
		} else if let insertString = insertRelativeCharacter(string, range: range) { string = "\(string)\(insertString)" }
	}
}
