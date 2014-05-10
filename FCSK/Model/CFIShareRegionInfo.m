//
//  CFIShareRegionInfo.m
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIShareRegionInfo.h"

static CFIShareRegionInfo *sharedInfo;

@implementation CFIShareRegionInfo

+(instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInfo = [[CFIShareRegionInfo alloc] init];
    });
    
    return sharedInfo;
}

@end
