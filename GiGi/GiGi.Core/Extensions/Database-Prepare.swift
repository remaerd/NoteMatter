//
//  Database-Prepare.swift
//  GiGi.Core
//
//  Created by Sean Cheng on 21/11/2017.
//

import Foundation
import CoreData

extension Database
{
	static func prepare() throws
	{
		try FileManager.default.createDirectory(at: URL.localDatabaseDirectory, withIntermediateDirectories: false, attributes: nil)
		Database.defaultDatabase = try Database(type: .default, modelURL: URL.defaultDatabaseModelUrl, url: URL.defaultDatabaseUrl)
		
		var folderType: Solution!
		var documentType: Solution!
		
		for solutionType in Solution.internalSolutions
		{
			let solution = try Solution.insert()
			solution.identifier = solutionType.identifier
			solution.title = solutionType.title
			solution.icon = solutionType.icon
			if solutionType == .document { documentType = solution } else if solutionType == .folder { folderType = solution }
		}
		
		let rootFolder = try Item.insert()
		rootFolder.title = Item.InternalItem.rootFolder.title
		rootFolder.solution = documentType
		try rootFolder.save()
		
		let welcomeDocument = try Item.insert()
		welcomeDocument.title = Item.InternalItem.welcome.title
		welcomeDocument.solution = documentType
		welcomeDocument.parent = rootFolder
		try welcomeDocument.save()
		
		let thumbDocument = try Item.insert()
		thumbDocument.title = Item.InternalItem.thumb.title
		thumbDocument.solution = documentType
		thumbDocument.parent = rootFolder
		try thumbDocument.save()
	}
}
