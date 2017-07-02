//
//  Localisation.swift
//  GiGi
//
//  Created by Zheng Xingzhi on 31/05/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

// A short version of the NSLocalizedString.

func LOCALE(_ localizedString: String, table : String? = nil) -> String
{
	return NSLocalizedString(localizedString, tableName: table, comment: "")
}
