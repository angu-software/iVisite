//
//  Patient.m
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Patient.h"
#import "Behandlung.h"


@implementation Patient

@synthesize name=_name, arzt=_arzt, aufnahme=_aufnahme, geschlecht=_geschlecht, behandlungen, arztId;

-(id)initWith:(NSString*)name Arzt:(Arzt*)arzt Geschlecht:(Geschlecht)geschlecht Aufnahme:(NSDate*)aufnahme{
	if(self == [super init]){
		self.name = name;
		self.arzt = arzt;
		self.geschlecht = geschlecht;
		self.aufnahme = aufnahme;
		behandlungen = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) add:(Behandlung*)behandlung{
	[behandlungen addObject:behandlung];
}

-(NSString*) toString{
	NSString* g = self.geschlecht == MAENNLICH? @"männlich" : @"weiblich";
	return [NSString stringWithFormat:@"%@;%@",self.name, g];
};

-(void)dealloc{
	[_name release];
	[_arzt release];
	[_aufnahme release];
	[behandlungen release];
	
	[super dealloc];
}

@end
