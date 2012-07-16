    //
//  CommunicationController.m
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommunicationController.h"

@implementation CommunicationController

@synthesize delegate;

-(id) init{
	if (self == [super init]) {
		receiveBuffer = [[NSMutableString alloc] init];
		currentState = STATE_WAIT_FOR_FRAME;
		delegate = nil;
	}
	
	return self;
}

#pragma mark UIKeyInput messages

-(void) insertText: (NSString*) text{
	if (delegate != nil) {
		
		//NSLog(@"Data received: %@",text);
		for (NSUInteger index = 0; index < [text length]; index++) {
			unichar c = [text characterAtIndex:index];
			c = [CommunicationController mapToASCII:c];
			if (c == FRAME_CHAR_START) {
				currentState = STATE_RECEIVE_FRAME;
				[receiveBuffer setString:@""];
			}else if (c == FRAME_CHAR_END) {
				currentState = STATE_WAIT_FOR_FRAME;
			}
			
			if (currentState == STATE_RECEIVE_FRAME) {
				[receiveBuffer appendFormat:@"%c",c];
			}else if ([receiveBuffer length] > 0) {
				[receiveBuffer appendFormat:@"%c",FRAME_CHAR_END];
				[delegate frameRecived:receiveBuffer];
				[receiveBuffer setString:@""];
			}

		}
	}
}

+(unichar) mapToASCII:(unichar)ch{
	switch (ch) {
		case 252: //ü
			return FRAME_CHAR_START;
			break;
		case 43: //+
			return FRAME_CHAR_END;
			break;
		case 167: //§
			return FRAME_CHAR_NUMBER;
			break;
		case 41: //)
			return FRAME_CHAR_TEXT_START;
			break;
		case 61: //=
			return FRAME_CHAR_TEXT_END;
			break;
		case 39: //'
			return FRAME_CHAR_SEPARATOR;
			break;
		case 'y':
			return (unichar)'z';
			break;
		case 'z':
			return (unichar)'y';
			break;



	}
	return ch;
}

-(void) deleteBackward{
	
}

-(BOOL) canBecomeFirstResponder{
	return YES;
}

-(BOOL) canResignFirstResponder{
	return NO;
}

-(void) touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event {
    [self becomeFirstResponder];
} 

-(BOOL) hasText{
	return NO;
}

#pragma mark inherited messages

- (void)dealloc {
	
	[receiveBuffer release];
	
    [super dealloc];
}


@end
