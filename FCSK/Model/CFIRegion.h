//
//  CFIRegion.h
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFIRegion : NSObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *name;

@property (nonatomic, strong)NSArray *booths;

@end
