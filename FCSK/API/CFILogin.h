//
//  MPMuseumItemDetails.h
//  Museum Pilot
//
//  Created by Mahesh on 4/5/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import "CFIApi.h"

@interface CFILogin : CFIApi

-(void) loginWithUserName:(NSString *)username passWord:(NSString *)password callBack:(responseCallBack) callBack;

@end
