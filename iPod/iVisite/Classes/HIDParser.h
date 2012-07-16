//
//  HIDParser.h
//  iVisite
//
//  Created by Andreas on 16.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HIDDataBlockDelegate.h"


@interface HIDParser : NSObject {

	NSMutableArray* data;
	NSObject<HIDDataBlockDelegate>* dataBlockDelegate;
	
	int frameCount;
	int currentFrame;
}

@property(nonatomic,assign) NSObject<HIDDataBlockDelegate>* dataBlockDelegate;

-(id) initWith:(NSObject<HIDDataBlockDelegate>*)dlegate;
-(void) parseFrame:(NSString*)frame;

@end
