//
//  Button.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 07/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

protocol DragableButtonDelegate: NSObjectProtocol
{
	func didTapped(dragableButton: DragableButton)
	func didPanned(dragableButton: DragableButton, toPoint: CGPoint)
	func shouldEnd(dragableButton: DragableButton, toPoint: CGPoint) -> Bool
}

class DragableButton: UIView
{
	weak var delegate: DragableButtonDelegate?

	override init(frame: CGRect)
	{
		super.init(frame: frame)
		backgroundColor = Theme.colors[6]
		layer.cornerRadius = Constants.bigButtonCornerRadius
		let image = #imageLiteral(resourceName: "List-Plus")
		let imageView = UIImageView(image: image)
		imageView.contentMode = .center
		imageView.tintColor = Theme.colors[0]
		self.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.bigButtonBottomMargin).isActive = true

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapped(gesture:))))
		addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanned(gesture:))))
	}

	@objc func didTapped(gesture: UITapGestureRecognizer)
	{
		delegate?.didTapped(dragableButton: self)
	}

	@objc func didPanned(gesture: UIPanGestureRecognizer)
	{
		let point = gesture.translation(in: self.superview)
		switch gesture.state
		{
		case .began:

			break
		case .changed:
			delegate?.didPanned(dragableButton: self, toPoint: point)
			self.transform = CGAffineTransform.init(translationX: point.x, y: point.y)
			break
		case .ended:
			if let delegate = delegate
			{
				let result = delegate.shouldEnd(dragableButton: self, toPoint: point)
				print(result)
			}
			UIView.animate(withDuration: Constants.defaultTransitionDuration / 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
			{
				self.transform = CGAffineTransform.identity
			}, completion: nil)
			break
		default:
			break
		}

	}

	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}

	override func tintColorDidChange()
	{
		super.tintColorDidChange()
	}
}
