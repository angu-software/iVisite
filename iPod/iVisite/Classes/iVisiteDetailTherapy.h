//
//  iVisiteDetailTherapy.h
//  iVisite
//
//  Created by mk on 02.02.11.
//  Copyright 2011 HTW Berlin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface iVisiteDetailTherapy : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	//Array of Behandlung objects
	NSMutableArray *selectedTherapy;
	IBOutlet UITextField *textBoxIst;
	IBOutlet UITextField *textBoxSoll;
	IBOutlet UITextView *textView;
}

@property(nonatomic, retain) NSMutableArray *selectedTherapy;
@property(nonatomic, retain) IBOutlet UITextField *textBoxIst;
@property(nonatomic, retain) IBOutlet UITextField *textBoxSoll;
@property(nonatomic, retain) IBOutlet UITextView *textView;



//Close the current view
- (IBAction)dismissView;
//Close the keyboard if the user press return
- (IBAction)textFieldShouldReturn:(id)sender;

@end

