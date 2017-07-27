//
//  ItemEditorViewController-KeyboardToolbar.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 16/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation
import GiGi

extension ItemEditorViewController : KeyboardToolbarDelegate
{
	func didSetParagraphStyle(style: ItemComponent.ComponentType)
	{
		do { try storage.setParagraphStyle(style: style) } catch { error.alert() }
	}
	
	func didSetTask(task: Task?)
	{
		
	}
	
	func didSetInlineStyle(style: ItemComponent.ComponentInnerStyle?)
	{
		
	}
	
	func didSetLink(url: URL?)
	{
		
	}
	
	func didSelectedBrace(string: String?)
	{
		
	}
	
	func didSelectedSingleQuote()
	{
		
	}
	
	func didSelectedCommonPunctuation(string: String?)
	{
		
	}
	
	func didDismissKeyboard()
	{
		editorView.resignFirstResponder()
	}
}
