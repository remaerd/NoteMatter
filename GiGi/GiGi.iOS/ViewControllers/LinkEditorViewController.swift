//
//  LinkEditorViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 11/12/2017.
//

import UIKit
import Cartography

class LinkEditorViewController: UIKit.UIViewController
{
	let bar = SegmentBar(titles: [".editor.link.web".localized, ".editor.link.section".localized, ".editor.link.document".localized])
	
	lazy var urlTextfield = UITextField()
	lazy var itemTableView = UITableView()
	
	let closeButton = UIButton()
	let containerView = UIView()
	var bottomConstraint: NSLayoutConstraint?
	
	init()
	{
		super.init(nibName: nil, bundle: nil)
		modalPresentationStyle = .custom
		transitioningDelegate = self
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboarWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool)
	{
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
	}
	
	override func loadView()
	{
		super.loadView()
		
		containerView.backgroundColor = Theme.colors[1]
		containerView.layer.cornerRadius = Constants.defaultCornerRadius
		
		closeButton.setImage(#imageLiteral(resourceName: "Navigation-Delete"), for: .normal)
		closeButton.tintColor = UIColor.white
		closeButton.layer.cornerRadius = 6
		closeButton.backgroundColor = UIColor.init(hex: "B9877B")

		view.addSubview(containerView)
		containerView.addSubview(bar)
		containerView.addSubview(closeButton)
		
		urlTextfield.backgroundColor = Theme.colors[0]
		urlTextfield.layer.cornerRadius = 6
		urlTextfield.keyboardType = .URL
		urlTextfield.returnKeyType = .done
		
		constrain(bar, closeButton, containerView)
		{
			bar, closeButton, container in
		
			container.height == 100
			container.leading == container.superview!.leading
			container.trailing == container.superview!.trailing
			bottomConstraint = container.bottom == container.superview!.bottom - 0
			
			closeButton.height == 30
			closeButton.width == 30
			closeButton.top == closeButton.superview!.top + Constants.edgeMargin
			closeButton.trailing == closeButton.superview!.trailing - Constants.edgeMargin
			
			bar.leading == bar.superview!.leading + Constants.edgeMargin
			bar.trailing == closeButton.leading - Constants.edgeMargin
			bar.top == bar.superview!.top + Constants.edgeMargin
			bar.height == 30
		}
		
		resetContainerView()
	}
	
	func resetContainerView()
	{
		urlTextfield.removeFromSuperview()
		itemTableView.removeFromSuperview()
		
		switch bar.index
		{
		case 0:
			containerView.addSubview(urlTextfield)
			urlTextfield.becomeFirstResponder()
			constrain(urlTextfield)
			{
				textfield in
				textfield.leading == textfield.superview!.leading + Constants.edgeMargin
				textfield.trailing == textfield.superview!.trailing - Constants.edgeMargin
				textfield.top == textfield.superview!.top + 50
				textfield.height == 30
			}
			break
		case 1:
			containerView.addSubview(urlTextfield)
			containerView.addSubview(itemTableView)
			break
		case 2:
			containerView.addSubview(urlTextfield)
			containerView.addSubview(itemTableView)
			break
		default: break
		}
	}
	
	@objc func keyboarWillShow(notification: NSNotification)
	{
		if let rectValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
		{
			let keyboardSize = rectValue.cgRectValue.size
			bottomConstraint?.constant = -keyboardSize.height + Constants.defaultCornerRadius
		}
	}
}

extension LinkEditorViewController: UITableViewDataSource
{
	func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		return cell
	}
}

extension LinkEditorViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		
	}
}

extension LinkEditorViewController: UIViewControllerTransitioningDelegate
{
	func presentationController(forPresented presented: UIKit.UIViewController, presenting: UIKit.UIViewController?, source: UIKit.UIViewController) -> UIPresentationController?
	{
		return ModalViewController(presentedViewController: presented, presenting: presenting)
	}
}
