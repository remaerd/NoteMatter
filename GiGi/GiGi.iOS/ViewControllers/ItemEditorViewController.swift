//
//  ItemEditorViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi
import Cartography

class ItemEditorViewController: UIViewController
{
	let keyboardToolbar = KeyboardToolbar()
	
	let storage: ContentStorage
	let editorView: UITextView
	var tap: UITapGestureRecognizer?
	var editorTopConstraint: NSLayoutConstraint?
	
	init(item:Item)
	{
		storage = ContentStorage(item:item)

		let manager = NSLayoutManager()
		
		let container = NSTextContainer()
		container.lineFragmentPadding = 0
		
		manager.addTextContainer(container)
		storage.addLayoutManager(manager)
		
		editorView = UITextView(frame: CGRect.zero, textContainer: container)
		
		super.init(nibName: nil, bundle: nil)
		
		editorView.delegate = self
		editorView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
		editorView.backgroundColor = Theme.colors[0]
		editorView.layer.cornerRadius = Constants.defaultCornerRadius
		editorView.inputAccessoryView = self.keyboardToolbar
		editorView.keyboardDismissMode = .interactive
		editorView.alwaysBounceVertical = true
		editorView.isSelectable = false
		editorView.isEditable = false
		
		keyboardToolbar.delegate = self
		
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
		
		title = storage.item.title
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
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		
	}
	
	override var prefersStatusBarHidden: Bool
	{
		return editorView.isEditable
	}
	
	override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
	{
		return UIStatusBarAnimation.slide
	}
}

extension ItemEditorViewController: UITextViewDelegate
{
	@objc func keyboardDidShow(notification: NSNotification)
	{
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
		setNeedsStatusBarAppearanceUpdate()
	}
	
	func textViewDidBeginEditing(_ textView: UITextView)
	{
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
	{
		return true
	}
	
	func textViewShouldEndEditing(_ textView: UITextView) -> Bool
	{
		storage.selectedRange = nil
		editorView.isEditable = false
		editorView.isSelectable = false
		tap?.isEnabled = true
		
		self.editorTopConstraint?.constant = Constants.statusBarHeight + Constants.edgeMargin * 2 + Constants.searchBarHeight
		UIView.animate(withDuration: Constants.defaultTransitionDuration / 2)
		{
			self.view.layoutIfNeeded()
		}
		hideSearchBar(hidden: false)
		setNeedsStatusBarAppearanceUpdate()
		return true
	}
	
	func textViewDidChangeSelection(_ textView: UITextView)
	{
		storage.selectedRange = textView.selectedRange
	}
}
