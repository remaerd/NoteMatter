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

	let storage: SyntaxRenderer
	let editorView: UITextView

	init(item:Item)
	{
		storage = SyntaxRenderer(item:item)

		let manager = NSLayoutManager()

		let container = NSTextContainer()
		container.lineFragmentPadding = 0

		manager.addTextContainer(container)
		storage.addLayoutManager(manager)

		editorView = UITextView(frame: CGRect.zero, textContainer: container)
		editorView.backgroundColor = Theme.colors[0]
		editorView.layer.cornerRadius = Constants.defaultCornerRadius

		super.init(nibName: nil, bundle: nil)
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
		editorView.contentInset = UIEdgeInsets.zero
		editorView.textContainerInset = UIEdgeInsets(top: 0, left: Constants.edgeMargin, bottom: 0, right: Constants.edgeMargin)
	}
}
