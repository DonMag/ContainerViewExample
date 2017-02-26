//
//  ContainerViewController.swift
//  SW3-ContainerViewTransition
//
//  Created by DonMag on 2/26/17.
//  Copyright © 2017 DonMag. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
	
	@IBOutlet weak var theContainerView: UIView!
	
	var theSenderVC: SenderViewController?
	var theDestinationVC: DestinationViewController?

	var theCurrentChildVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		// get a reference to the Storyboard
		let sb = UIStoryboard(name: "Main", bundle: nil)
		
		// instantiate view controllers - in a real app, this likely will be done only when the VC is needed
		theSenderVC = sb.instantiateViewController(withIdentifier: "SBSender") as? SenderViewController
		theDestinationVC = sb.instantiateViewController(withIdentifier: "SBDestination") as? DestinationViewController

		// make sure they loaded (avoids forced unwrapping)
		guard let svc = theSenderVC else {
			return
		}
		guard let _ = theDestinationVC else {
			return
		}

		// add initial Child VC - the "Sender" in this example
		self.addChildViewController(svc)
		
		svc.view.frame = theContainerView.bounds
		
		// add child's view to the container view
		theContainerView.addSubview(svc.view)
		
		// finish flow
		theSenderVC?.didMove(toParentViewController: self)
		
		// track which VC is active
		theCurrentChildVC = theSenderVC
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func swapTapped(_ sender: Any) {
		
		guard let svc = theSenderVC else {
			return
		}
		
		guard let dvc = theDestinationVC else {
			return
		}
		
		if theCurrentChildVC == theSenderVC {
			
			self.cycle(from: svc, to: dvc, direction: UIViewAnimationOptions.transitionFlipFromLeft)
			
		} else {
			
			self.cycle(from: dvc, to: svc, direction: UIViewAnimationOptions.transitionFlipFromRight)
			
		}

	}
	
	func cycle(from oldVC: UIViewController,
	           to newVC: UIViewController,
	           direction: UIViewAnimationOptions) -> Void {
		
		// prepare for the transition
		oldVC.willMove(toParentViewController: nil)
		
		self.addChildViewController(newVC)
		
		newVC.view.frame = theContainerView.bounds
		
		UIView.transition(
			with: theContainerView,
			duration: 0.4,
			options: direction,
			animations: {
				oldVC.view.removeFromSuperview()
				self.theContainerView.addSubview(newVC.view)
		}, completion: {
			finished in
			self.theCurrentChildVC = newVC
		})
		
	}
	
}
