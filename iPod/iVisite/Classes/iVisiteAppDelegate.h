//
//  iVisiteAppDelegate.h
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iVisiteViewController;

@interface iVisiteAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iVisiteViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iVisiteViewController *viewController;

//-(IBAction)showAbout;

@end

