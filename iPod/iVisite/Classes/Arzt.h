//
//  Arzt.h
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Arzt : NSObject {

	NSString *_mobileId;
	NSString *_name;
	NSString* _arzt_id;
	
}

@property(copy) NSString *mobileId;
@property(copy) NSString *name;
@property(copy) NSString *arztId;

-(id)initWith:(NSString*)name Geraet:(NSString*)mobileId;
-(NSString*) toString;

@end
