//
//  TodayViewController.swift
//  GiGi.iOS.Today
//
//  Created by Sean Cheng on 19/11/2017.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		// Do any additional setup after loading the view from its nib.
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
	{
		completionHandler(NCUpdateResult.newData)
	}
}
