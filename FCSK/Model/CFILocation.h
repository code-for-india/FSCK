//
//  CFILocation.h
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFIRegion.h"

@interface CFILocation : NSObject

@property (nonatomic, copy)NSNumber *latitude;
@property (nonatomic, copy)NSNumber *longitude;
@property (nonatomic, strong)NSNumber *travellerDensity;
@property (nonatomic, copy)NSString *ID;
@property (strong, nonatomic) NSString *name;

@end
