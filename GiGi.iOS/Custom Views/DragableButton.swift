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
	let imageView: UIImageView

	override init(frame: CGRect)
	{
		imageView = UIImageView(image: #imageLiteral(resourceName: "List-Plus"))

		super.init(frame: frame)
		backgroundColor = Theme.colors[6]
		layer.cornerRadius = Constants.bigButtonCornerRadius

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
			UIView.animate(withDuration: Constants.defaultTransitionDuration / 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
			{
				self.imageView.alpha = 0
				self.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
			}, completion: nil)
			break
		case .changed:
			delegate?.didPanned(dragableButton: self, toPoint: gesture.location(in: self.superview))
			self.transform = CGAffineTransform.init(translationX: point.x, y: point.y - Constants.bigButtonBottomMargin).scaledBy(x: 1.2, y: 1.2)
			break
		case .ended:
			if let delegate = delegate
			{
				let result = delegate.shouldEnd(dragableButton: self, toPoint: point)
				print(result)
			}
			UIView.animate(withDuration: Constants.defaultTransitionDuration / 2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
			{
				self.imageView.alpha = 1
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
