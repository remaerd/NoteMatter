//
//  ReminderEditorViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 11/12/2017.
//

import UIKit

class ReminderEditorViewController: UIKit.UIViewController
{
	override func loadView()
	{
		
	}
}

extension ReminderEditorViewController: UIViewControllerTransitioningDelegate
{
	func presentationController(forPresented presented: UIKit.UIViewController, presenting: UIKit.UIViewController?, source: UIKit.UIViewController) -> UIPresentationController?
	{
		return ModalViewController(presentedViewController: presented, presenting: presenting)
	}
}
