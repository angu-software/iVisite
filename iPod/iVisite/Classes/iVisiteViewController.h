//
//  iVisiteViewController.h
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Controller.h"

@interface iVisiteViewController : UIViewController<MainControllerDelegate> {

	Controller* mainController;
	
	UIView* containerView;
	NSMutableArray* listData;
	IBOutlet UIProgressView* progressBar;
	IBOutlet UILabel* progressLabel;
}

@property(nonatomic, retain) IBOutlet UIView* containerView;
@property(nonatomic, retain) IBOutlet UIProgressView* progressBar;
@property(nonatomic, retain) IBOutlet UILabel* progressLabel;
@property(retain) NSMutableArray* listData;

-(IBAction)simulateStart;
-(void) resetData;
-(void) showTableView;



@end

