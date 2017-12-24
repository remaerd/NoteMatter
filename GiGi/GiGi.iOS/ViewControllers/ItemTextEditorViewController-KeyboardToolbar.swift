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
		let result = storage.setParagraphStyle(range: self.editorView.selectedRange)
		editorView.selectedRange = result.newRange
		paragraphStyleButton.selectedIndex = result.index
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
		let viewController = LinkEditorViewController()
		present(viewController, animated: true, completion: nil)
	}
	
	@objc func didSelectedBrace()
	{
		Sound.tapCell.play()
		let result = storage.setBrace(range: self.editorView.selectedRange)
		self.editorView.selectedRange = result.newRange
		braceButton.selectedIndex = result.index
	}
	
	@objc func didTappedQuoteButton()
	{
		Sound.tapCell.play()
		self.editorView.selectedRange = storage.setSingleQuote(range: self.editorView.selectedRange)
	}
	
	@objc func didTappedPunctuation()
	{
		Sound.tapCell.play()
		let result = storage.setPunctuation(range: self.editorView.selectedRange)
		self.editorView.selectedRange = result.newRange
		punctuationButton.selectedIndex = result.index
	}
	
	@objc func didTappedDismissButton()
	{
		editorView.resignFirstResponder()
	}
}
