//
//  SiriManager.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 21/11/2017.
//

import Foundation
import Intents

@available(iOS, introduced: 11.0)
public class SiriManager
{
	public static var shared = SiriManager()
	
	public var status: INSiriAuthorizationStatus
	{
		return INPreferences.siriAuthorizationStatus()
	}
	
	public func activate(completion: @escaping (_ status: INSiriAuthorizationStatus) -> Void)
	{
		INPreferences.requestSiriAuthorization { (status) in
			completion(status)
		}
	}
}
