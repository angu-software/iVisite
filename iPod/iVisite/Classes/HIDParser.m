//
//  HIDParser.m
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HIDParser.h"
#import "CommunicationController.h"


@implementation HIDParser

@synthesize dataBlockDelegate;

-(id) initWith:(NSObject<HIDDataBlockDelegate>*)delegate{

	if (self == [super init]) {
		dataBlockDelegate = delegate;
		data = [[NSMutableArray alloc] init];
		
	}
	
	return self;
}

-(void) parseFrame:(NSString*)frame {
	NSLog(@"Parsing frame: %@", frame);
	NSString* transportFrameChars = [NSString stringWithFormat:@"%c%c%c%c",
									 FRAME_CHAR_START,
									 FRAME_CHAR_END,
									 FRAME_CHAR_NUMBER,
									 FRAME_CHAR_TEXT_START,
									 FRAME_CHAR_END];
	NSCharacterSet* controlChars = [NSCharacterSet characterSetWithCharactersInString:transportFrameChars];
	NSScanner* scanner = [NSScanner scannerWithString:frame];
	[scanner setScanLocation:1];
	NSString* frameType = nil; // frame type
	NSString* numberID = nil; // number or ID of frame (depends on frame Type)

	
	if ([scanner scanUpToCharactersFromSet:controlChars intoString:&frameType] &&	// read frame type
		[scanner scanCharactersFromSet:controlChars intoString:NULL] &&				// skip one character (FRAME_CHAR_NUMBER)
		[scanner scanUpToCharactersFromSet:controlChars intoString:&numberID]) {	// read number or ID
		//NSLog(@"FrameType: %d", [frameType intValue]);
		//NSLog(@"NumberID: %@", numberID);
		
		switch ([frameType intValue]) {
			case 0: // FRAME_TYPE_INITIAL
				frameCount = [numberID intValue];
				currentFrame=0;
				[data removeAllObjects];
				//NSLog(@"Frame Type FRAME_TYPE_INITIAL");
				//NSLog(@"Following frames: %d",frameCount);
				break;
			case 1: // FRAME_TYPE_DATA
				currentFrame = [numberID intValue]; //workarround
				//currentFrame++;
				//NSLog(@"Frame Type FRAME_TYPE_DATA");
				//NSLog(@"Frame number: %d", currentFrame);
				
				if (currentFrame <= frameCount-1) {
					NSString* dataFrame;
					//NSLog(@"scanner pointer: %d", [scanner scanLocation]);
					if ([scanner scanCharactersFromSet:controlChars intoString:NULL] &&	//skip one character (FRAME_CHAR_TEXT_START)
						[scanner scanUpToCharactersFromSet:controlChars intoString:&dataFrame]) { //read data
						
						dataFrame = [dataFrame substringToIndex:dataFrame.length - 1];// clear last control character
						//NSLog(@"Data frame: %@", dataFrame);
						//collect data
						[(NSMutableArray*)data addObject:[dataBlockDelegate parseHIDData:dataFrame frameCount:frameCount framesLeft:frameCount-currentFrame]]; //create a data object
					}else {
						//NSLog(@"No valid dataFrame");
					}
				}
				if (currentFrame == frameCount-1) {
					// provide all data
					NSArray* dataCopy = [NSArray arrayWithArray:data];
					[dataBlockDelegate dataAvailable:dataCopy];
				}
				 
				break;
			default:
				NSLog(@"Not suported frame type!");
				break;
		}
		
	}
}

-(void) dealloc {
	
	[dataBlockDelegate release];
	[data release];
	
	[super dealloc];
}

@end
