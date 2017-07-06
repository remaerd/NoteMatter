//
//  ItemEditorViewController.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class ItemEditorViewController: UIViewController
{
	override var searchPlaceHolder : String? { return storage.item.title }

	let storage: ContentStorage
	let editorView: UITextView
	var tap: UITapGestureRecognizer?

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
		editorView.textContainerInset = UIEdgeInsets(top: Constants.edgeMargin, left: Constants.edgeMargin, bottom: Constants.edgeMargin, right: Constants.edgeMargin)
		editorView.backgroundColor = Theme.colors[0]
		editorView.textColor = Theme.colors[6]
		editorView.font = Theme.EditorRegularFont
		editorView.layer.cornerRadius = Constants.defaultCornerRadius
//		editorView.tintColor = Theme.colors[0]
		editorView.isEditable = false
		editorView.isSelectable = false
		editorView.keyboardDismissMode = .interactive
		editorView.alwaysBounceVertical = true

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

		view.addSubview(editorView)
		editorView.translatesAutoresizingMaskIntoConstraints = false
		editorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		editorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		editorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		editorView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.statusBarHeight + Constants.edgeMargin * 2 + Constants.searchBarHeight).isActive = true
	}
}

extension ItemEditorViewController: UITextViewDelegate
{
	@objc func didTappedEditor(gesture:UITapGestureRecognizer)
	{
		tap!.isEnabled = false
		editorView.isEditable = true
		editorView.isSelectable = true
		if let range = selectedRangeInTextView() { editorView.selectedRange = range }
		editorView.becomeFirstResponder()
	}

	func textViewDidBeginEditing(_ textView: UITextView)
	{
	}

	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
	{
		return true
	}

	func textViewDidEndEditing(_ textView: UITextView)
	{
		editorView.isEditable = false
		editorView.isSelectable = false
		tap?.isEnabled = true
	}

	func selectedRangeInTextView() -> NSRange?
	{
		let beginning = editorView.beginningOfDocument
		let selectedRange = editorView.selectedTextRange
		if let selectionStart = selectedRange?.start, let selectionEnd = selectedRange?.end
		{
			let location = editorView.offset(from: beginning, to: selectionStart)
			let length = editorView.offset(from: selectionStart, to: selectionEnd)
			return NSRange(location: location, length: length)
		}
		return nil
	}
}
