//
//  ViewController.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 26/06/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import GiGi

class LaunchViewController: UIViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		view.backgroundColor = UIColor(hex: "282A2E")
	}

	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		do
		{
			try Application.start()
			navigationController?.setViewControllers([ItemListViewController()], animated: animated)

		} catch
		{
			print(error)
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle
	{
		return UIStatusBarStyle.lightContent
	}

	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
