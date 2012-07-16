//
//  CommunicationDelegate.h
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommunicationController;

@protocol CommunicationDelegate

-(void) frameRecived:(NSString*)dataFrame;

@end
