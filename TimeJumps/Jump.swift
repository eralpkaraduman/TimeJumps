//
//  Jump.swift
//  TimeJumps
//
//  Created by Eralp Karaduman on 04/03/16.
//  Copyright © 2016 Super Damage. All rights reserved.
//

import Foundation

struct Jump {

	var date: NSDate

	func serialize() -> NSDictionary {
		return NSDictionary(dictionary: [
				"date": date.timeIntervalSince1970
			])
	}

	static func deserialize(dictionary: NSDictionary) -> Jump? {
		if let internval = dictionary.valueForKey("date") as? NSTimeInterval {
			return Jump(date: NSDate(timeIntervalSince1970: internval))
		} else {
			return nil
		}
	}
}