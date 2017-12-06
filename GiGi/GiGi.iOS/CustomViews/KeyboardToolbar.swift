//
//  KeyboardToolbar.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi
import Cartography

protocol KeyboardToolbarDelegate: NSObjectProtocol
{
	func didSetParagraphStyle(style: ItemComponent.ComponentType)
	func didSetTask(task: Task?)
	func didSetInlineStyle(style: ItemComponent.ComponentInnerStyle?)
	func didSetLink(url: URL?)
	func didSelectedBrace(string: String?)
	func didSelectedSingleQuote()
	func didSelectedCommonPunctuation(string: String?)
	func didDismissKeyboard()
}

class KeyboardButton: UIButton
{
	convenience init(image: UIImage)
	{
		self.init(frame: CGRect.zero)
		layer.cornerRadius = 4
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowColor = Theme.colors[3].cgColor
		backgroundColor = Theme.colors[0]
		adjustsImageWhenHighlighted = false
		tintColor = Theme.colors[5]
		setImage(image, for: .normal)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesBegan(touches, with: event)
		backgroundColor = Theme.colors[5]
		imageView?.tintColor = Theme.colors[0]
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesEnded(touches, with: event)
		if let _ = touches.first
		{
			backgroundColor = Theme.colors[0]
			imageView?.tintColor = Theme.colors[5]
		}
	}
}

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

class KeyboardToolbar: UIView
{
	let toolbarView : UIView
	let taskView = UIView()
	let paragraphStyleButton = SlidableKeyboardButton(buttons: styles, showTitle: true)
	let taskButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-Task"))
	let inlineStyleButton = SlidableKeyboardButton(buttons: inlineStyle, image: #imageLiteral(resourceName: "Keyboard-Bold"))
	let linkButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-Link"))
	let braceButton = SlidableKeyboardButton(buttons: braces, alignRight: true, nullable: true)
	let quoteButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-SingleQuote"))
	let punctuationButton = SlidableKeyboardButton(buttons: punctuations, alignRight: true, nullable: true)
	let dismissButton = KeyboardButton(image: #imageLiteral(resourceName: "Keyboard-Dismiss"))
	
	weak var delegate: KeyboardToolbarDelegate?
	
	init()
	{
		toolbarView = UIView()
		super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.keyboardBarHeight))
		
		if Theme.isMorning { backgroundColor = UIColor.init(hex: "D2D5DB") } else { backgroundColor = UIColor.init(hex: "1A1A1A") }
		tintColor = Theme.colors[6]
		taskView.isHidden = true
		var lastView: UIView?
		var firstView: UIView?
		let views = [dismissButton, punctuationButton, quoteButton, braceButton, linkButton, inlineStyleButton, taskButton, paragraphStyleButton] as [UIView]
		for _view in views
		{
			toolbarView.addSubview(_view)
			if let _lastView = lastView
			{
				constrain(_view, _lastView)
				{
					view, lastView in
					if views.index(of: _view) == views.count - 1 { view.width == lastView.width * 2 } else { view.width == lastView.width }
					view.centerY == view.superview!.centerY
					view.trailing == lastView.leading - 5
					view.height == 44
				}
				lastView = _view
			}
			else
			{
				firstView = _view
				lastView = _view
				constrain(_view)
				{
					view in
					view.centerY == view.superview!.centerY
					view.trailing == view.superview!.trailing - 22
					view.height == 44
				}
			}
		}
		
		constrain(lastView!)
		{
			view in
			view.leading == view.superview!.leading + 22
		}
		
		addSubview(toolbarView)
		addSubview(taskView)
		
		constrain(taskView, toolbarView)
		{
			view, toolbar in
			toolbar.edges == view.superview!.edges
			view.leading == view.superview!.leading
			view.trailing == view.superview!.trailing
			view.bottom == toolbar.top
			view.height == Constants.keyboardTaskBarHeight
		}
		
		paragraphStyleButton.addTarget(self, action: #selector(didSelectParagraphStyle), for: .touchUpInside)
		taskButton.addTarget(self, action: #selector(didTappedTaskButton), for: .touchUpInside)
		inlineStyleButton.addTarget(self, action: #selector(didSelectedInlineParagraphStyle), for: .touchUpInside)
		linkButton.addTarget(self, action: #selector(didTappedLinkButton), for: .touchUpInside)
		braceButton.addTarget(self, action: #selector(didSelectedBrace), for: .touchUpInside)
		quoteButton.addTarget(self, action: #selector(didTappedQuoteButton), for: .touchUpInside)
		punctuationButton.addTarget(self, action: #selector(didTappedPunctuation), for: .touchUpInside)
		dismissButton.addTarget(self, action: #selector(didTappedDismissButton), for: .touchUpInside)
	}
	
	@objc func didSelectParagraphStyle()
	{
		switch paragraphStyleButton.selectedIndex
		{
		case 0: delegate?.didSetParagraphStyle(style: .body); break
		case 1: delegate?.didSetParagraphStyle(style: .header1); break
		case 2: delegate?.didSetParagraphStyle(style: .header2); break
		case 3: delegate?.didSetParagraphStyle(style: .header3); break
		case 4: delegate?.didSetParagraphStyle(style: .unorderedListItem); break
		case 5: delegate?.didSetParagraphStyle(style: .orderedListItem); break
		case 6: delegate?.didSetParagraphStyle(style: .quote); break
		default: break
		}
	}
	
	@objc func didTappedTaskButton()
	{
		delegate?.didSetTask(task: nil)
	}
	
	@objc func didSelectedInlineParagraphStyle()
	{
		delegate?.didSetInlineStyle(style: nil)
	}
	
	@objc func didTappedLinkButton()
	{
		delegate?.didSetLink(url: nil)
	}
	
	@objc func didSelectedBrace()
	{
		delegate?.didSelectedBrace(string: nil)
	}
	
	@objc func didTappedQuoteButton()
	{
		delegate?.didSelectedSingleQuote()
	}
	
	@objc func didTappedPunctuation()
	{
		delegate?.didSelectedCommonPunctuation(string: nil)
	}
	
	@objc func didTappedDismissButton()
	{
		delegate?.didDismissKeyboard()
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}

