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
		Database.standard = try Database(type: .default, modelURL: URL.defaultDatabaseModelUrl, url: URL.defaultDatabaseUrl)
		
		var folderType: Template!
		var documentType: Template!
		
		for templateType in Template.internalTemplates
		{
			let template = try Template.insert()
			template.identifier = templateType.identifier
			template.title = templateType.title
			template.icon = templateType.icon
			if templateType == .folder { template.isFolder = true }
			if templateType == .document { documentType = template } else if templateType == .folder { folderType = template }
		}
		
		let rootFolder = try Item.insert()
		rootFolder.title = Item.InternalItem.rootFolder.title
		rootFolder.template = folderType
		try rootFolder.save()
		
		let welcomeDocument = try Item.insert()
		welcomeDocument.title = Item.InternalItem.welcome.title
		welcomeDocument.template = documentType
		welcomeDocument.parent = rootFolder
		try welcomeDocument.save()
		
		let thumbDocument = try Item.insert()
		thumbDocument.title = Item.InternalItem.thumb.title
		thumbDocument.template = documentType
		thumbDocument.parent = rootFolder
		try thumbDocument.save()
	}
}
