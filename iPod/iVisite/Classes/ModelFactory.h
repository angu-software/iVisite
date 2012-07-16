//
//  ModelFactory.h
//  iVisite
//
//  Created by Andreas on 26.11.10.
//  Copyright 2010 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Patient.h"
#import "Arzt.h"
#import "Behandlung.h"

@interface ModelFactory : NSObject {
	
	NSDateFormatter *dateFormatter;
	NSMutableDictionary* arztDict;
	NSMutableDictionary* patientDict;
	NSMutableDictionary* behandlungDict;
}

-(Arzt*) createArzt:(NSArray*) data;
-(Patient*) createPatient:(NSArray*) data;
-(Behandlung*) createBehandlung:(NSArray*) data;

@end
