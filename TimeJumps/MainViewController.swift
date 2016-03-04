//
//  ViewController.swift
//  TimeJumps
//
//  Created by Eralp Karaduman on 04/03/16.
//  Copyright © 2016 Super Damage. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	@IBOutlet weak var todayCount: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "jumpsUpdated", name: JumpManager.UpdateNotification, object: nil)
		jumpsUpdated();

		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTriggerTap:");
		self.view.addGestureRecognizer(tapGestureRecognizer);

	}

	func didTriggerTap(recognizer: UITapGestureRecognizer) {

		let jump = JumpManager.shared.recordJump();
		undoManager?.registerUndoWithTarget(self, selector: "didUndo:", object: jump.serialize())
		undoManager?.setActionName("record time jump")
		
	}

	func jumpsUpdated() {
		todayCount.text = "\(JumpManager.shared.jumpsToday)"
	}

	func didUndo(serializedJump: NSDictionary) {

		guard let jump = Jump.deserialize(serializedJump) else {
			return;
		}

		JumpManager.shared.removeJump(jump)
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		becomeFirstResponder()
		jumpsUpdated();
	}

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		resignFirstResponder()
	}

	override func canBecomeFirstResponder() -> Bool {
		return true
	}


}

