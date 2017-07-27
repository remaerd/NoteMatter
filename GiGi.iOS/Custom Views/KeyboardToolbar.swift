//
//  KeyboardToolbar.swift
//  GiGi
//
//  Created by Sean Cheng on 02/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

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
		layer.shadowColor = Theme.colors[1].cgColor
		showsTouchWhenHighlighted = false
		backgroundColor = Theme.colors[0]
		tintColor = Theme.colors[5]
		setImage(image, for: .normal)
	}
	
	override func didMoveToSuperview()
	{
		super.didMoveToSuperview()
		translatesAutoresizingMaskIntoConstraints = false
		widthAnchor.constraint(equalToConstant: Constants.keyboardButtonWidth).isActive = true
		heightAnchor.constraint(equalToConstant: Constants.keyboardButtonHeight).isActive = true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesBegan(touches, with: event)
		backgroundColor = Theme.colors[5]
		tintColor = Theme.colors[0]
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		super.touchesEnded(touches, with: event)
		if let _ = touches.first
		{
			backgroundColor = Theme.colors[0]
			tintColor = Theme.colors[5]
		}
	}
}

let styles = [(#imageLiteral(resourceName: "Keyboard-Regular"),".style.paragraph.regular".localized),
              (#imageLiteral(resourceName: "Keyboard-H1"),".style.paragraph.header1".localized),
              (#imageLiteral(resourceName: "Keyboard-H2"),".style.paragraph.header2".localized),
              (#imageLiteral(resourceName: "Keyboard-H3"),".style.paragraph.header3".localized),
              (#imageLiteral(resourceName: "Keyboard-List"),".style.paragraph.list".localized),
              (#imageLiteral(resourceName: "Keyboard-NumList"),".style.paragraph.numlist".localized),
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
	let toolbarView : UIStackView
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
		toolbarView = UIStackView(arrangedSubviews: [paragraphStyleButton, taskButton, inlineStyleButton, linkButton, braceButton, quoteButton, punctuationButton, dismissButton])
		super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constants.keyboardBarHeight))
		
		backgroundColor = Theme.colors[2]
		tintColor = Theme.colors[6]
		
		toolbarView.spacing = Constants.keyboardButtonMargin
		toolbarView.distribution = .fill
		toolbarView.alignment = .center
		toolbarView.axis = .horizontal
		taskView.isHidden = true
		
		addSubview(toolbarView)
		addSubview(taskView)
		
		toolbarView.translatesAutoresizingMaskIntoConstraints = false
		toolbarView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		toolbarView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		
		taskView.translatesAutoresizingMaskIntoConstraints = false
		taskView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		taskView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		taskView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor).isActive = true
		taskView.heightAnchor.constraint(equalToConstant: Constants.keyboardTaskBarHeight).isActive = true
		
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
		case 4: delegate?.didSetParagraphStyle(style: .dashListItem); break
		case 5: delegate?.didSetParagraphStyle(style: .numberedListItem); break
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

