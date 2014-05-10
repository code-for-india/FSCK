//
//  CFIGetCheckPostDetails.h
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIApi.h"

@interface CFIGetCheckPostDetails : CFIApi

- (void)getCheckPostDetailsWithId:(NSString *)ID callback:(responseCallBack)callback;

@end
