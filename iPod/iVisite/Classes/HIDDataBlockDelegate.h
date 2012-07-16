//
//  HIDParserDelegate.h
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HIDParser;

@protocol HIDDataBlockDelegate

-(NSObject*) parseHIDData:(NSString*)dataFrame frameCount:(int)numCount framesLeft:(int)numLeft;
-(void) dataAvailable:(NSArray*)data;

@end
