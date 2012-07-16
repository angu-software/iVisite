//
//  Behandlung.h
//  iVisite
//
//  Created by Andreas on 02.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h";


@interface Behandlung : NSObject {
	NSDate *_planTermin;
	NSDate * _istTermin;
	NSString *_beschreibung;
	Patient *_patient;
}

@property(copy) NSDate *planTermin;
@property(copy) NSDate *istTermin;
@property(copy) NSString *beschreibung;
@property(retain) Patient *patient;

-(id)initWith:(NSString*)beschreibung Patient:(Patient*)person Termin:(NSDate*)plan;
-(NSString*) toString;

@end
