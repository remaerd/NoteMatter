//
//  Button.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 07/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit

@objc protocol DragableButtonDelegate: NSObjectProtocol
{
	@objc optional func didTapped(dragableButton: DragableButton)
	@objc optional func didPanned(dragableButton: DragableButton, toPoint: CGPoint) -> CGFloat
	@objc optional func didEnd(dragableButton: DragableButton, toPoint: CGPoint)
}

class DragableButton: UIView
{
	weak var delegate: DragableButtonDelegate?
	let imageView: UIImageView
	
	override init(frame: CGRect)
	{
		imageView = UIImageView(image: #imageLiteral(resourceName: "List-Plus"))
		
		super.init(frame: frame)
		layer.cornerRadius = Constants.bigButtonCornerRadius
		imageView.contentMode = .center
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
		delegate?.didTapped?(dragableButton: self)
	}
	
	@objc func didPanned(gesture: UIPanGestureRecognizer)
	{
		let point = gesture.translation(in: self.superview)
		switch gesture.state
		{
		case .began:
			UIView.animate(withDuration: Constants.defaultTransitionDuration / 2, delay: Constants.defaultTransitionDuration / 2, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations:
				{
					self.imageView.transform = CGAffineTransform(translationX: 0, y: Constants.bigButtonBottomMargin / 2).rotated(by: 0.8)
			}, completion: nil)
			break
		case .changed:
			self.transform = CGAffineTransform.init(translationX: point.x, y: point.y - Constants.bigButtonBottomMargin)
			guard let newAlpha = delegate?.didPanned?(dragableButton: self, toPoint: gesture.location(in: self.superview)) else { return }
			if newAlpha != alpha { UIView.animate(withDuration: 0.2, animations: { self.alpha = newAlpha }) }
			break
		case .ended:
			if let delegate = delegate { delegate.didEnd?(dragableButton: self, toPoint: point) }
			UIView.animate(withDuration: Constants.defaultTransitionDuration / 1.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations:
				{
					self.alpha = 1
					self.imageView.transform = CGAffineTransform.identity
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
}

