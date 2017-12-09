//
//  ItemEditorViewController-KeyboardToolbar.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 16/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation
import GiGi

extension ItemTextEditorViewController
{
	@objc func didSelectParagraphStyle()
	{
		Sound.tapCell.play()
		editorView.selectedRange = storage.setParagraphStyle(range: self.editorView.selectedRange)
	}
	
	@objc func didTappedTaskButton()
	{
		Sound.tapCell.play()
		editorView.selectedRange = storage.toggleTask(range: self.editorView.selectedRange)
	}
	
	@objc func didSelectedInlineParagraphStyle()
	{
		Sound.tapCell.play()
		editorView.selectedRange = storage.setInlineStyle(range: self.editorView.selectedRange)
	}
	
	@objc func didTappedLinkButton()
	{
		Sound.tapCell.play()
//		do { storage.setLink(range: self.editorView.selectedRange, url: url) } catch { error.alert() }
	}
	
	@objc func didSelectedBrace()
	{
		Sound.tapCell.play()
		editorView.selectedRange = storage.setBrace(range: self.editorView.selectedRange)
	}
	
	@objc func didTappedQuoteButton()
	{
		Sound.tapCell.play()
		self.editorView.selectedRange = storage.setSingleQuote(range: self.editorView.selectedRange)
	}
	
	@objc func didTappedPunctuation()
	{
		Sound.tapCell.play()
	}
	
	@objc func didTappedDismissButton()
	{
		editorView.resignFirstResponder()
	}
}
