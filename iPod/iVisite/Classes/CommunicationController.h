//
//  CommunicationController.h
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationDelegate.h"

#define STATE_RECEIVE_FRAME 0
#define STATE_WAIT_FOR_FRAME 1

#define FRAME_CHAR_START 91 //[->ü 252
#define FRAME_CHAR_END 93//]->+ 43
#define FRAME_CHAR_TEXT_START 40//(->) 41
#define FRAME_CHAR_TEXT_END 41 //)->= 61

#define FRAME_TYPE_INITIAL 48
#define FRAME_TYPE_DATA 49
#define FRAME_CHAR_NUMBER 35 //#->§ 167
#define FRAME_CHAR_SEPARATOR 124 //|->' 39

@interface CommunicationController : UIView<UIKeyInput> {
	
	NSObject<CommunicationDelegate>* delegate;
	
	NSMutableString* receiveBuffer;
	int currentState;
}

@property(nonatomic,assign) NSObject<CommunicationDelegate>* delegate;
+(unichar) mapToASCII:(unichar)ch;

@end
