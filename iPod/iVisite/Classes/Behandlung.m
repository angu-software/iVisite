//
//  Behandlung.m
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Behandlung.h"


@implementation Behandlung

@synthesize planTermin=_planTermin, istTermin=_istTermin, beschreibung=_beschreibung, patient=_patient;

-(id)initWith:(NSString*)beschreibung Patient:(Patient*)patient Termin:(NSDate*)datum {
	if (self==[super init]) {
		self.patient = patient;
		self.beschreibung = beschreibung;
		self.planTermin = datum;
		self.istTermin = [NSDate distantPast];
	}
	return self;
}

-(NSString*) toString{
	return [NSString stringWithFormat:@"%@",self.beschreibung];
};


-(void)dealloc{

	[_patient release];
	[_beschreibung release];
	[_planTermin release];
	[_istTermin release];
	
	[super dealloc];
}

@end
