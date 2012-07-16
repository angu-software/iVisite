//
//  InputSimulator.h
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationController.h"


@interface InputSimulator : NSObject {

	CommunicationController* communicationController;
	NSMutableArray* dataPool;
	NSThread* simulatorTread;
	bool onlineTest;
}

@property(retain) CommunicationController* communicationController;
@property bool onlineTest;

-(void)runSimulation;
-(void) simulateInput:(NSObject*)param;
-(void) setUpDataPool;
-(NSString*) getOnlineDataForMobileId:(NSString*) mobileId;

@end
