//
//  Controller.m
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Controller.h"
#import "InputSimulator.h"
#import "DataController.h"
#import "ModelFactory.h"

#define TESTPARSER 0

@implementation Controller
@synthesize parent;
@synthesize arzt;
@synthesize delegate;

-(id) init{
	if (self == [super init]) {
		
		communicationController = [[CommunicationController alloc] init];
		[communicationController setFrame:[self bounds]];
		[self insertSubview:communicationController atIndex:0];
		[communicationController becomeFirstResponder];
		[communicationController setDelegate:self];
		
		frameParser = [[HIDParser alloc] initWith:self];
		
		patientArray = [[NSMutableArray alloc] init];
		behandlungArray = [[NSMutableArray alloc] init];
		
		[self setUserInteractionEnabled:YES];
	}
	return self;
}

#pragma mark private messages

-(void) run{

	if (TESTPARSER == 1) {
		InputSimulator* inSim = [[InputSimulator alloc] init];
		[inSim setCommunicationController:communicationController];
		inSim.onlineTest = NO;
		[inSim runSimulation];
		
		[inSim release];
	}

}

-(void) stop{
	
}

#pragma mark CommunicationDelegate messages

-(void) frameRecived:(NSString*)dataFrame {
	[frameParser parseFrame:dataFrame];
}

#pragma mark HIDDataBlockDelegate messages

-(NSObject*) parseHIDData:(NSString*)dataFrame frameCount:(int)numCount framesLeft:(int)numLeft {
	
	if (delegate!=nil) {
		float progress = (float)(numCount - (numLeft - 1))/(float)numCount;
		[delegate progressOnParsingData:progress];
	}
	
	NSLog(@"Data to Parse: %@",dataFrame);
	return dataFrame;
}

-(void) resetData{
	if(arzt != nil){
		[arzt release];
		arzt = nil;
	}
	[patientArray removeAllObjects];
	[patientArray release];
	patientArray = [[NSMutableArray alloc] init];
	[behandlungArray removeAllObjects];
	[behandlungArray release];
	behandlungArray = [[NSMutableArray alloc] init];
}

-(void) dataAvailable:(NSArray*)data {
	
	ModelFactory* modelFactory = [[ModelFactory alloc] init];
	
	NSLog(@"%d data objects available", [data count]);
	for (int index = 0; index < [data count]; index++) {
		NSString* dataString = [data objectAtIndex:index];
		
		NSString* separator = [NSString stringWithFormat:@"%c", FRAME_CHAR_SEPARATOR];
		NSArray* objData = [dataString componentsSeparatedByString:separator];
		
		int entityID = [(NSString*)[objData objectAtIndex:0] intValue];
		
		switch (entityID) {
			case 0: // ENTITY_TYPE_ARZT
			{
				//NSLog(@"ENTITY_TYPE_ARZT");
				[self setArzt:[modelFactory createArzt:objData]];
				break;
			}
			case 1: // ENTITY_TYPE_PATIENT
			{
				//NSLog(@"ENTITY_TYPE_PATIENT");
				Patient* patient = [modelFactory createPatient:objData];
				[patient setArzt:arzt];
				[patientArray addObject:patient];
				break;
			}
			case 2: // ENTITY_TYPE_BEHANDLUNG
			{
				//NSLog(@"ENTITY_TYPE_BEHANDLUNG");
				Behandlung* behandlung = [modelFactory createBehandlung:objData];
				[behandlungArray addObject:behandlung];
				break;
			}
			default:
				break;
		}
		
	}
	
	[modelFactory release];

	[parent setListData:patientArray];
	[parent showTableView];
	
}

-(BOOL) array:(NSArray*)aArray Contains:(id)string{
	for (id obj in aArray) {
		if ([obj isEqual:string]) {
			return YES;
		}
	}
	return NO;
}

#pragma mark inherited messages

-(void) dealloc {
	
	if(arzt != nil){
		[arzt release];
	}
	[patientArray release];
	[behandlungArray release];
	[communicationController setDelegate:nil];
	[communicationController release];
	
	[super dealloc];
}

@end
