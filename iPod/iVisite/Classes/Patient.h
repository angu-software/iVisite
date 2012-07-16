//
//  Patient.h
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arzt.h"

@class Behandlung;

typedef enum{
	MAENNLICH = 0,
	WEIBLICH = 1

}Geschlecht;

@interface Patient : NSObject {
	NSString *_name;
	Geschlecht _geschlecht;
	NSDate *_aufnahme;
	Arzt *_arzt;
	NSString* arztId;
	NSMutableArray* beandlungen;
}

@property(copy) NSString *arztId;
@property(copy) NSString *name;
@property(retain) Arzt *arzt;
@property(copy) NSDate *aufnahme;
@property Geschlecht geschlecht;
@property(retain) NSMutableArray* behandlungen;

-(id)initWith:(NSString *)name Arzt:(Arzt *)arzt Geschlecht:(Geschlecht)gender Aufnahme:(NSDate *)aufnahme;
-(void) add:(Behandlung*)behandlung;
-(NSString*) toString;

@end
