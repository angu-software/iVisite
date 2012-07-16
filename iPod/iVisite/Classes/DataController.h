//
//  DataController.h
//  iVisite
//
//  Created by Andreas on 14.12.10.
//  Copyright 2010 HTW Berlin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const HOST_URL;

@interface DataController : NSObject {

}

-(NSString*) getDataForDoc:(NSString*) docId;

@end
