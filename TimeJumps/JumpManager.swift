//
//  JumpManager.swift
//  TimeJumps
//
//  Created by Eralp Karaduman on 04/03/16.
//  Copyright © 2016 Super Damage. All rights reserved.
//

import Foundation
import UIKit

class JumpManager {

	static let UpdateNotification = "JumpManagerUpdateNotification"

	static let shared = JumpManager()

	init() {

	}

	func recordJump() -> Jump {

		let jump = Jump(date: now)
		addJump(jump)
		dispatchChangeNotification();
		return jump
	}

	private func addJump(jump: Jump) {
		let def = NSUserDefaults.standardUserDefaults()

		if let jumps = def.objectForKey("jumps") as? [NSDictionary] {
			var j = jumps;
			let serializedJump = jump.serialize()
			j.append(serializedJump)
			def.setObject(j, forKey: "jumps")
		} else {
			let jumps = [NSDictionary]()
			def.setObject(jumps, forKey: "jumps")
			def.synchronize()
			addJump(jump)
		}

	}

	func removeJump(jump: Jump) {
		var allJumps = getJumps()

		let jumpsToRemove = allJumps.filter { (jmp) -> Bool in
			return jmp.date.timeIntervalSince1970 == jump.date.timeIntervalSince1970
		}

		if let removeJump = jumpsToRemove.first,
			let removeIndex = allJumps.indexOf({ return $0.date == removeJump.date }) {
				allJumps.removeAtIndex(removeIndex)
		}

		var serializedJumps = [NSDictionary]()
		for jump in allJumps {
			serializedJumps.append(jump.serialize())
		}

		let def = NSUserDefaults.standardUserDefaults()
		def.setObject(serializedJumps, forKey: "jumps")
		def.synchronize()

		dispatchChangeNotification()

	}

	private func getJumps() -> [Jump] {

		let def = NSUserDefaults.standardUserDefaults()

		if let jumpDatas = def.objectForKey("jumps") as? [NSDictionary] {

			var jumps = [Jump]()

			for jumpData in jumpDatas {
				if let jump = Jump.deserialize(jumpData) {
					jumps.append(jump)
				}
			}

			return jumps
		}

		return [Jump]();

	}

	var now: NSDate {
		return NSDate()
	}

	func undoJump() {

	}

	func dispatchChangeNotification() {
		NSNotificationCenter.defaultCenter().postNotificationName(
			JumpManager.UpdateNotification,
			object: nil)
	}

	var jumpsToday: Int {
		return getJumps().count;
	}

	var jumpsAll: Int {
		return getJumps().count;
	}

}