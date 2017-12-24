//
//  ItemTextEditorViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi
import Cartography

class ItemTextEditorViewController: UIViewController
{
	let keyboardToolbar: KeyboardToolbar
	
	let storage: ContentStorage
	let editorView: UITextView
	var tap: UITapGestureRecognizer!
	var editorTopConstraint: NSLayoutConstraint?
	
	let paragraphStyleButton: SlidableKeyboardButton
	let taskButton: KeyboardButton
	let inlineStyleButton: SlidableKeyboardButton
	let linkButton: KeyboardButton
	let braceButton: SlidableKeyboardButton
	let quoteButton: KeyboardButton
	let punctuationButton: SlidableKeyboardButton
	let dismissButton: KeyboardButton
	
	init(item:Item)
	{
		let styles = [(#imageLiteral(resourceName: "Keyboard-Regular"),".style.paragraph.regular".localized),
									(#imageLiteral(resourceName: "Keyboard-H1"),".style.paragraph.header1".localized),
									(#imageLiteral(resourceName: "Keyboard-H2"),".style.paragraph.header2".localized),
									(#imageLiteral(resourceName: "Keyboard-H3"),".style.paragraph.header3".localized),
									(#imageLiteral(resourceName: "Keyboard-List"),".style.paragraph.unordered".localized),
									(#imageLiteral(resourceName: "Keyboard-NumList"),".style.paragraph.ordered".localized),
									(#imageLiteral(resourceName: "Keyboard-Quote"),".style.paragraph.quote".localized)]
		
		let inlineStyle = [(#imageLiteral(resourceName: "Keyboard-Regular"),".style.inline.regular".localized),
											 (#imageLiteral(resourceName: "Keyboard-Bold"),".style.inline.bold".localized),
											 (#imageLiteral(resourceName: "Keyboard-Italic"),".style.inline.italic".localized),
											 (#imageLiteral(resourceName: "Keyboard-Strikethrough"),".style.inline.strikethrough".localized),
											 (#imageLiteral(resourceName: "Keyboard-Placeholder"),".style.inline.placeholder".localized)]
		
		let braces = [(#imageLiteral(resourceName: "Keyboard-DoubleQuote"),".style.brace.double-quote".localized),
									(#imageLiteral(resourceName: "Keyboard-RoundBrace"),".style.brace.rounded".localized),
									(#imageLiteral(resourceName: "Keyboard-SquareBrace"),".style.brace.square".localized),
									(#imageLiteral(resourceName: "Keyboard-CurlyBrace"),".style.brace.curly".localized)]
		
		let punctuations = [(#imageLiteral(resourceName: "Keyboard-Comma"),".style.punctuation.comma".localized),
												(#imageLiteral(resourceName: "Keyboard-Period"),".style.punctuation.peroid".localized),
												(#imageLiteral(resourceName: "Keyboard-Exclamation"),".style.punctuation.exclamation".localized),
												(#imageLiteral(resourceName: "Keyboard-Question"),".style.punctuation.question".localized)]
		
		paragraphStyleButton = SlidableKeyboardButton(buttons: styles, showTitle: true)
		taskButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-Task"))
		inlineStyleButton = SlidableKeyboardButton(buttons: inlineStyle, image: #imageLiteral(resourceName: "Keyboard-Bold"))
		linkButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-Link"))
		braceButton = SlidableKeyboardButton(buttons: braces, alignRight: true)
		quoteButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-SingleQuote"))
		punctuationButton = SlidableKeyboardButton(buttons: punctuations, alignRight: true)
		dismissButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-Dismiss"))
		
		let views = [dismissButton, punctuationButton, quoteButton, braceButton, linkButton, inlineStyleButton, taskButton, paragraphStyleButton] as [UIView]
		keyboardToolbar = KeyboardToolbar(views: views)
		
		ContentStorage.item = item
		storage = ContentStorage()
		storage.isEditing = true
		
		let manager = NSLayoutManager()
		let container = NSTextContainer()
		container.lineFragmentPadding = 0
		
		manager.addTextContainer(container)
		storage.addLayoutManager(manager)
		
		editorView = UITextView(frame: CGRect.zero, textContainer: container)
		
		super.init(nibName: nil, bundle: nil)
		
		paragraphStyleButton.addTarget(self, action: #selector(didSelectParagraphStyle), for: .touchUpInside)
		taskButton.addTarget(self, action: #selector(didTappedTaskButton), for: .touchUpInside)
		inlineStyleButton.addTarget(self, action: #selector(didSelectedInlineParagraphStyle), for: .touchUpInside)
		linkButton.addTarget(self, action: #selector(didTappedLinkButton), for: .touchUpInside)
		braceButton.addTarget(self, action: #selector(didSelectedBrace), for: .touchUpInside)
		quoteButton.addTarget(self, action: #selector(didTappedQuoteButton), for: .touchUpInside)
		punctuationButton.addTarget(self, action: #selector(didTappedPunctuation), for: .touchUpInside)
		dismissButton.addTarget(self, action: #selector(didTappedDismissButton), for: .touchUpInside)
		
		editorView.delegate = self
		editorView.tintColor = Theme.colors[8]
		editorView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
		editorView.backgroundColor = Theme.colors[0]
		editorView.textColor = Theme.colors[7]
		editorView.layer.cornerRadius = Constants.defaultCornerRadius
		editorView.inputAccessoryView = self.keyboardToolbar
		editorView.keyboardDismissMode = .interactive
		editorView.alwaysBounceVertical = true
		editorView.isSelectable = false
		editorView.isEditable = false
		
		if Theme.isMorning { editorView.keyboardAppearance = .light } else { editorView.keyboardAppearance = .dark }
		
		tap = UITapGestureRecognizer(target: self, action: #selector(didTappedEditor(gesture:)))
		editorView.addGestureRecognizer(tap!)
	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView()
	{
		super.loadView()
		
		title = ContentStorage.item!.title
		view.addSubview(editorView)
		
		constrain(editorView)
		{
			editor in
			editor.leading == editor.superview!.leading
			editor.trailing == editor.superview!.trailing
			editor.bottom == editor.superview!.bottom
			editorTopConstraint = editor.top == editor.superview!.top + Constants.statusBarHeight + Constants.edgeMargin * 2 + Constants.searchBarHeight
		}
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChanged(notification:)), name: .UITextInputCurrentInputModeDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboarWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: .UIKeyboardDidHide, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: .UITextInputCurrentInputModeDidChange, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
		do { try ContentStorage.item?.save() }
		catch { error.alert() }
	}
}

extension ItemTextEditorViewController: UITextViewDelegate
{
	@objc func keyboardDidChanged(notification: NSNotification)
	{
		storage.language = editorView.textInputMode?.primaryLanguage
	}
	
	@objc func keyboardWillHide(notification: NSNotification)
	{
		if tap?.isEnabled == false
		{
			Sound.keyboardDown.play()
		}
		tap?.isEnabled = true
	}
	
	@objc func keyboarWillShow(notification: NSNotification)
	{
		Sound.keyboardUp.play()
		if let rectValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
		{
			let keyboardSize = rectValue.cgRectValue.size
			editorView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15 + keyboardSize.height, right: 15)
		}
	}
	
	@objc func keyboardDidHide(notification: NSNotification)
	{
		editorView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
	}
	
	@objc func didTappedEditor(gesture:UITapGestureRecognizer)
	{
		gesture.isEnabled = false
		editorView.isEditable = true
		editorView.isSelectable = true
		let beginning = editorView.beginningOfDocument
		let range = editorView.characterRange(at: gesture.location(in: editorView))
		if let selectionStart = range?.start
		{
			let location = editorView.offset(from: beginning, to: selectionStart)
			editorView.selectedRange = NSRange(location: location + 1, length: 0)
		}
		editorView.becomeFirstResponder()
		self.editorTopConstraint?.constant = 0
		UIView.animate(withDuration: Constants.defaultTransitionDuration / 2)
		{
			self.view.layoutIfNeeded()
		}
		hideSearchBar(hidden: true)
	}
	
	func textViewDidEndEditing(_ textView: UITextView)
	{
		editorView.isEditable = false
		editorView.isSelectable = false
		self.editorTopConstraint?.constant = Constants.statusBarHeight + Constants.edgeMargin * 2 + Constants.searchBarHeight
		UIView.animate(withDuration: Constants.defaultTransitionDuration / 2)
		{
			self.view.layoutIfNeeded()
		}
		hideSearchBar(hidden: false)
	}
	
	func textViewDidChangeSelection(_ textView: UITextView)
	{
		let paragraphIndex = storage.paragraphIndex(range: self.editorView.selectedRange).location
		let type = ContentStorage.item!.components[paragraphIndex].componentType
		let styleIndex: Int
		switch type
		{
		case .body: styleIndex = 1; break
		case .header1:  styleIndex = 2; break
		case .header2:  styleIndex = 3; break
		case .header3:  styleIndex = 4; break
		case .unorderedListItem:  styleIndex = 5; break
		case .orderedListItem:  styleIndex = 6; break
		case .quote:  styleIndex = 7; break
		}
		paragraphStyleButton.selectedIndex = styleIndex
	}
	
}
