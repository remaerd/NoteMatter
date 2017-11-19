//
//  Alert.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 13/07/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import UIKit
import Sentry

extension Error
{
	func alert()
	{
		var description = ""
		if let localizedError = self as? LocalizedError, let string = localizedError.errorDescription { description = string }
		let alertController = UIAlertController(title: title.localized, message: description.localized, preferredStyle: .alert)
		UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
		print(self)
	}
	
	var title: String { return ".error.title.\(Int(arc4random_uniform(9)))" }
}

