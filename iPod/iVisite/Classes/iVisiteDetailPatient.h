//
//  iVisiteDetailPatient.h
//  iVisite
//
//  Created by mk on 02.02.11.
//  Copyright 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iVisiteDetailTherapy.h"

@interface iVisiteDetailPatient : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	//Array of selected Patient objects, normally only one object
	NSMutableArray *selectedPatient;
	//Array of Behandlung objects of the selected user
	NSMutableArray *selectedTherapys;
	iVisiteDetailTherapy *therapieDetailView;
}

@property(nonatomic, retain) NSMutableArray *selectedPatient;
@property(nonatomic, retain) NSMutableArray *selectedTherapys;

//Close the current view
- (IBAction)dismissView;

@end
