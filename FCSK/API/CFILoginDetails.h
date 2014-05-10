//
//  MPMuseumItemDetails.h
//  Museum Pilot
//
//  Created by Mahesh on 4/5/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import "CFIApi.h"

@interface CFILoginDetails : CFIApi

- (void)getMuseumDataWithUDID:(NSString *)UDID ID:(NSString *)ID majorId:(NSString *)majorID minorID:(NSString *)minorID callback:(responseCallBack)callback;

-(void) loginWithUserName:(NSString *)username passWord:(NSString *)password callBack:(responseCallBack) callBack;

@end
