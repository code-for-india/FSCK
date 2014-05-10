//
//  CFIGetRoute.h
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIApi.h"
#import "CFILocation.h"

@interface CFIGetRoute : CFIApi

- (void)getRouteFrom:(CFILocation *)from to:(CFILocation *)to callback:(responseCallBack)callback;

@end
