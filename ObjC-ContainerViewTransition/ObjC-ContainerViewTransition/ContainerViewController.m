//
//  ContainerViewController.m
//  ObjC-ContainerViewTransition
//
//  Created by DonMag on 2/26/17.
//  Copyright © 2017 DonMag. All rights reserved.
//

#import "ContainerViewController.h"

#import "SenderViewController.h"
#import "DestinationViewController.h"

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet UIView *theContainerView;

@property (strong, nonatomic) SenderViewController *theSenderVC;
@property (strong, nonatomic) DestinationViewController *theDestinationVC;

@property (strong, nonatomic) UIViewController *theCurrentChildVC;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// get a reference to the Storyboard
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

	// instantiate view controllers - in a real app, this likely will be done only when the VC is needed
	_theSenderVC = [sb instantiateViewControllerWithIdentifier:@"SBSender"];
	_theDestinationVC = [sb instantiateViewControllerWithIdentifier:@"SBDestination"];

	// add initial Child VC - the "Sender" in this example
	[self addChildViewController:_theSenderVC];

	_theSenderVC.view.frame = _theContainerView.bounds;
	
	// add child's view to the container view
	[_theContainerView addSubview:_theSenderVC.view];
	
	// finish flow
	[_theSenderVC didMoveToParentViewController:self];
	
	// track which VC is active
	_theCurrentChildVC = _theSenderVC;
	
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)swapTapped:(id)sender {
	
	if (_theCurrentChildVC == _theSenderVC) {
		
		[self cycleFromViewController:_theSenderVC toViewController:_theDestinationVC direction:UIViewAnimationOptionTransitionFlipFromLeft];
		
	} else {
		
		[self cycleFromViewController:_theDestinationVC toViewController:_theSenderVC direction:UIViewAnimationOptionTransitionFlipFromRight];
		
	}
	
}

- (void)cycleFromViewController: (UIViewController*) oldVC
			   toViewController: (UIViewController*) newVC
					  direction: (UIViewAnimationOptions) opt
{
	
	// prepare for the transition
	[oldVC willMoveToParentViewController:nil];
	
	[self addChildViewController:newVC];
 
	newVC.view.frame = _theContainerView.bounds;
	
	[UIView transitionWithView:_theContainerView
					  duration:0.4
					   options:opt
					animations:^{
						[oldVC.view removeFromSuperview];
						[_theContainerView addSubview:newVC.view];
					}
					completion:^(BOOL finished){
						_theCurrentChildVC = newVC;
					}];
	
}


@end
