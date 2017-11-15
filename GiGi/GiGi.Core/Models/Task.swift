//
//  Task.swift
//  GiGi.iOS
//
//  Created by Sean Cheng on 14/11/2017.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject, Model
{
	public static var database: Database { return Database.defaultDatabase }
}
