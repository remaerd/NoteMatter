//
//  ItemEditorViewController-KeyboardToolbar.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 16/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation
import GiGi

extension ItemTextEditorViewController : KeyboardToolbarDelegate
{
	func didSetParagraphStyle(style: ItemComponent.ComponentType)
	{
		Sound.tapCell.play()
//		do { try storage.setParagraphStyle(style: style) } catch { error.alert() }
	}
	
	func didSetTask(task: Task?)
	{
		Sound.tapCell.play()
	}
	
	func didSetInlineStyle(style: ItemComponent.ComponentInnerStyle?)
	{
		Sound.tapCell.play()
	}
	
	func didSetLink(url: URL?)
	{
		Sound.tapCell.play()
	}
	
	func didSelectedBrace(string: String?)
	{
		Sound.tapCell.play()
	}
	
	func didSelectedSingleQuote()
	{
		Sound.tapCell.play()
	}
	
	func didSelectedCommonPunctuation(string: String?)
	{
		Sound.tapCell.play()
	}
	
	func didDismissKeyboard()
	{
		Sound.tapCell.play()
		editorView.resignFirstResponder()
	}
}
