//
//  MPApi.h
//  Museum Pilot
//
//  Created by Mahesh on 4/5/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const baseURL;

typedef void (^responseCallBack)(id responseData, NSError *error, BOOL success);

@interface CFIApi : NSObject

@end
