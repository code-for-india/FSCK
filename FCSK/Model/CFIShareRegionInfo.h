//
//  CFIShareRegionInfo.h
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFIRegion.h"
#import "CFICurrentBooth.h"


@interface CFIShareRegionInfo : NSObject

@property(strong, nonatomic)CFIRegion *currentRegion;
@property(strong, nonatomic)CFICurrentBooth *currentBuuth;

+(instancetype)sharedInstance;

@end
