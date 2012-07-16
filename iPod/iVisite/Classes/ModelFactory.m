//
//  ModelFactory.m
//  iVisite
//
//  Created by Andreas on 26.11.10.
//  Copyright 2010 HTW Berlin. All rights reserved.
//

#import "ModelFactory.h"


@implementation ModelFactory

-(id) init{
	if (self == [super init]) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"ddMMyyyy"];
		arztDict = [[NSMutableDictionary alloc]init];
		patientDict = [[NSMutableDictionary alloc]init];
		behandlungDict = [[NSMutableDictionary alloc]init];
	}
	
	return self;
}

-(Arzt*) createArzt:(NSArray*) data{
	
	NSString* name = [NSString stringWithString:[data objectAtIndex:1]];
	NSString* arztId = (NSString*)[data objectAtIndex:2];
	NSString* mobileId = (NSString*)[data objectAtIndex:3];
	
	NSLog(@"%@; %@; %@", name, arztId, mobileId);
	
	Arzt* arzt = [[Arzt alloc] initWith:name Geraet:mobileId];
	[arzt setArztId:arztId];
	
	[arztDict setObject:arzt forKey:arztId];
	
	return [arzt autorelease];
}

-(Patient*) createPatient:(NSArray*) data{
	
	NSString* name = [data objectAtIndex:1];
	
	Geschlecht gender = MAENNLICH;
	if ([(NSString*)[data objectAtIndex:2] isEqualToString:@"w"]) {
		gender = WEIBLICH;
	}
	
	NSDate *aufnahme = [dateFormatter dateFromString: [data objectAtIndex:3]];
	NSString* arztId = [data objectAtIndex:4];
	NSString* patId = [data objectAtIndex:5];
	
	Arzt* arzt = [arztDict valueForKey:arztId];
	
	Patient* patient = [[Patient alloc] initWith:name Arzt:arzt Geschlecht:gender Aufnahme:aufnahme];
	
	[patientDict setObject:patient forKey:patId];
	
	return [patient autorelease];
}

-(Behandlung*) createBehandlung:(NSArray*) data{
	
	NSString* beschreib = [data objectAtIndex:1];
	NSDate* planDate = [dateFormatter dateFromString:[data objectAtIndex:2]];
	NSDate* istDate = [dateFormatter dateFromString:[data objectAtIndex:3]];
	NSString* patientId = [data objectAtIndex:4];
	NSString* behandlungId = [data objectAtIndex:5];
	
	Patient* patient = [patientDict valueForKey:patientId];
	
	Behandlung* behandlung = [[Behandlung alloc] initWith:beschreib Patient:patient Termin:planDate];
	behandlung.istTermin = istDate;
	
	[patient add:behandlung];
	
	[behandlungDict setObject:behandlung forKey:behandlungId];
	
	return [behandlung autorelease];
}

-(void) dealloc{

	[dateFormatter release];
	[arztDict release];
	[patientDict release];
	[behandlungDict release];
	
	[super dealloc];
}

@end
