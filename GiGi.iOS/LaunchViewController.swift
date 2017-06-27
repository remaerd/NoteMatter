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
		if state.database.status == .invalidDatabase
		{
			print("Cannot load database")
		} else if state.theme.status == .invalidThemeData
		{
			print("Cannot load theme")
		} else if state.database.status == .loaded
		{
			UIView.animate(withDuration: 1.0, animations:
			{
				self.view.backgroundColor = state.theme.dayPallette[1]
			})
		} else if state.database.status == .firstLaunch
		{
			gigi.dispatch(DatabaseActions.Prepare())
		} else if state.theme.status == .loaded
		{
			gigi.dispatch(DatabaseActions.Load())
		}
	}
}
