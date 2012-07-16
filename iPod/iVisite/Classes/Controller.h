//
//  Controller.h
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommunicationController.h"
#import "HIDParser.h"
#import "Arzt.h"

@class iVisiteViewController;

@protocol MainControllerDelegate

-(void) progressOnParsingData:(float)progress;

@end

@interface Controller : UIView <CommunicationDelegate,HIDDataBlockDelegate>{
	
	CommunicationController* communicationController;
	HIDParser* frameParser;
	iVisiteViewController* parent;
	Arzt* arzt;
	NSMutableArray* patientArray;
	NSMutableArray* behandlungArray;
	NSObject<MainControllerDelegate>* delegate;
}

@property(retain) iVisiteViewController* parent;
@property(retain) Arzt* arzt;
@property(retain) NSObject<MainControllerDelegate>* delegate;

-(void) run;
-(void) stop;
-(void) resetData;

@end
