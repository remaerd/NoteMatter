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

		view.addSubview(editorView)
		editorView.translatesAutoresizingMaskIntoConstraints = false
		editorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		editorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		editorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		editorTopConstraint = editorView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.statusBarHeight + Constants.edgeMargin * 2 + Constants.searchBarHeight)
		editorTopConstraint!.isActive = true
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
	@objc func didTappedEditor(gesture:UITapGestureRecognizer)
	{
		tap!.isEnabled = false
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

	func textViewDidEndEditing(_ textView: UITextView)
	{
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
	}
}
