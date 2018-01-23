//
//  CardViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 16/1/2018.
//

import UIKit
import Cartography

class CardViewController: UIViewController
{
	override func loadView()
	{
		super.loadView()
		let cardView = UIView()
		constrain(cardView)
		{
			(card) in
			card.leading == card.superview!.leading + Constants.edgeMargin
			card.trailing == card.superview!.trailing - Constants.edgeMargin
			card.top == card.superview!.top + Constants.edgeMargin + Constants.statusBarHeight
			card.bottom == card.superview!.left - Constants.edgeMargin
		}
	}
}

