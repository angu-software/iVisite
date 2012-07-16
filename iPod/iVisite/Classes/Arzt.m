//
//  Arzt.m
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Arzt.h"


@implementation Arzt

@synthesize mobileId=_mobileId, name=_name, arztId=_arzt_id;

-(id)initWith:(NSString*)name Geraet:(NSString*)mobileId{
	if (self == [super init]) {
		self.name = name;
		self.mobileId = mobileId;
	}
	return self;
}

-(NSString*) toString{
	return [NSString stringWithFormat:@"%@;%@", self.name, self.mobileId];
}

-(void)dealloc{

	[_name release];
	[super dealloc];
}
@end
