//
//  Localisation.swift
//  GiGi
//
//  Created by Zheng Xingzhi on 31/05/2017.
//  Copyright © 2017 Zheng Xingzhi. All rights reserved.
//

import Foundation

// A short version of the NSLocalizedString.
extension String
{
	var localized: String
	{
		return NSLocalizedString(self, tableName: nil, comment: "")
	}
}
