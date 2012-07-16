//
//  DataController.m
//  iVisite
//
//  Created by Andreas on 14.12.10.
//  Copyright 2010 HTW Berlin. All rights reserved.
//

#import "DataController.h"

NSString* const HOST_URL = @"http://mk.base23.de/ivisite/server/interface/ivisite_test.php?arzt_id=";

@implementation DataController

-(NSString*) getDataForDoc:(NSString*) docId{
	NSError* error;
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOST_URL, docId]];
	NSString* urlContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	
	return urlContent;
}

@end
