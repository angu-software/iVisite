//
//  InputSimulator.m
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InputSimulator.h"
#import "DataController.h"


@implementation InputSimulator

@synthesize communicationController, onlineTest;

-(id) init{
	if (self == [super init]) {
		communicationController = nil;
		simulatorTread = [[NSThread alloc] initWithTarget:self selector:@selector(simulateInput:) object:nil];
		dataPool = [[NSMutableArray alloc] init];
		[self setUpDataPool];
		
		onlineTest = NO;
	}
	
	return self;
}

-(void) setUpDataPool{
	
	NSString* initFormat = @"%c%c%@%@%c";
	NSString* dataFrameFormat = @"%c%c%@%@%c%@%c%c";
	
	NSString* data1 = [NSString stringWithFormat:@"0%cDr. House%c123456", FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR];
	NSString* data2 = [NSString stringWithFormat:@"0%cDr. Frankenstein%c987654", FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR];
	NSString* data3 = [NSString stringWithFormat:@"1%cHerr Fuchs%cm%c15092010%c1", FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR,FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR];
	NSString* data4 = [NSString stringWithFormat:@"1%cFrau Elster%cf%c15092010%c2", FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR,FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR];
	NSString* data5 = [NSString stringWithFormat:@"2%cMassage%c16092010%c16092010%c2", FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR,FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR];
	NSString* data6 = [NSString stringWithFormat:@"2%cFussbad%c16092010%c16092010%c2", FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR,FRAME_CHAR_SEPARATOR, FRAME_CHAR_SEPARATOR];
	
	[dataPool addObject:[[NSString alloc] initWithFormat:initFormat,FRAME_CHAR_START,FRAME_TYPE_INITIAL,@"#",@"6",FRAME_CHAR_END]];
	[dataPool addObject:[[NSString alloc] initWithFormat:dataFrameFormat,FRAME_CHAR_START,FRAME_TYPE_DATA,@"#",@"0",FRAME_CHAR_TEXT_START,data1,FRAME_CHAR_TEXT_END,FRAME_CHAR_END]];
	[dataPool addObject:[[NSString alloc] initWithFormat:dataFrameFormat,FRAME_CHAR_START,FRAME_TYPE_DATA,@"#",@"1",FRAME_CHAR_TEXT_START,data2,FRAME_CHAR_TEXT_END,FRAME_CHAR_END]];
	[dataPool addObject:[[NSString alloc] initWithFormat:dataFrameFormat,FRAME_CHAR_START,FRAME_TYPE_DATA,@"#",@"2",FRAME_CHAR_TEXT_START,data3,FRAME_CHAR_TEXT_END,FRAME_CHAR_END]];
	[dataPool addObject:[[NSString alloc] initWithFormat:dataFrameFormat,FRAME_CHAR_START,FRAME_TYPE_DATA,@"#",@"3",FRAME_CHAR_TEXT_START,data4,FRAME_CHAR_TEXT_END,FRAME_CHAR_END]];
	[dataPool addObject:[[NSString alloc] initWithFormat:dataFrameFormat,FRAME_CHAR_START,FRAME_TYPE_DATA,@"#",@"4",FRAME_CHAR_TEXT_START,data5,FRAME_CHAR_TEXT_END,FRAME_CHAR_END]];
	[dataPool addObject:[[NSString alloc] initWithFormat:dataFrameFormat,FRAME_CHAR_START,FRAME_TYPE_DATA,@"#",@"5",FRAME_CHAR_TEXT_START,data6,FRAME_CHAR_TEXT_END,FRAME_CHAR_END]];
	
	[initFormat release];
	[dataFrameFormat release];
	
}

-(void) simulateInput:(id)param{
	NSAutoreleasePool* myPool = [[NSAutoreleasePool alloc] init];
	if (communicationController != nil) {
		while (YES) {
			for (int index = 0; index < [dataPool count]; index++) {
				if (onlineTest) {
					[communicationController insertText:[self getOnlineDataForMobileId:[NSString stringWithFormat:@"%i",index]]];
				}else {
					[communicationController insertText:[dataPool objectAtIndex:index]];
				}
				[NSThread sleepForTimeInterval:0.5];
			}
			[NSThread sleepForTimeInterval:1];
		}
	}
	[myPool release];
}

-(NSString*) getOnlineDataForMobileId:(NSString*) mobileId{
	DataController* dc = [[DataController alloc] init];
	NSString* data = [dc getDataForDoc:mobileId];
	[dc release];
	return data;
}

-(void)runSimulation{
	NSLog(@"Input simulator running...");
	[simulatorTread start];
	//[self simulateInput:nil];
}

-(void) stopSimulation{
	NSLog(@"Input simulator stopped...");
	[simulatorTread cancel];
}

-(void) dealloc{
	
	if ([simulatorTread isExecuting]) {
		[simulatorTread	cancel];
	}
	[communicationController release];
	[simulatorTread release];
	[dataPool release];
	[super dealloc];
}

@end
