//
//  iVisiteListPatients.h
//  iVisite
//
//  Created by mk on 01.02.11.
//  Copyright 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iVisiteViewController.h"
#import "iVisiteDetailPatient.h"

@interface iVisiteListPatients : UIViewController<UITableViewDelegate,UITableViewDataSource>{
	//List of all Patient objects of the current doctor
	NSMutableArray *listData;
	iVisiteDetailPatient* patientDetailView;
	iVisiteViewController* parent;
}


@property(retain) NSMutableArray *listData;
@property(retain) iVisiteViewController* parent;

//Shows the About screen
-(IBAction)showAbout;
-(IBAction) dissmissView;
- (void)setDummyData;

@end
