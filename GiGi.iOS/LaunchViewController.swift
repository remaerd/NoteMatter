//
//  ViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import ReSwift
import GiGi

class LaunchViewController: UIViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		view.backgroundColor = UIColor(hex: "282A2E")
	}

	override func viewWillAppear(_ animated: Bool)
	{
		super.viewWillAppear(animated)
		gigi.subscribe(self)
		gigi.dispatch(ThemeActions.Load())
		print("Launching App")
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

extension LaunchViewController : StoreSubscriber
{
	typealias StoreSubscriberStateType = AppState

	func newState(state: AppState)
	{
		if let error = state.database.error
		{
			print(error)
		} else if let error = state.theme.error
		{
			print(error)
		} else if state.database.privateDatabase != nil
		{
			start()
		} else if state.theme.currentTheme != nil
		{
			gigi.dispatch(DatabaseActions.Load())
		}
	}

	func start()
	{
		UIView.animate(withDuration: 1.0, animations:
		{
			self.view.backgroundColor = gigi.state.theme.currentTheme?.dayPallette[1]
		})
	}
}
