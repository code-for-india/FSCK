//
//  MPMuseum.h
//  Museum Pilot
//
//  Created by Mahesh on 4/4/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import "CFIBaseitem.h"


@interface CFIUserDetails : CFIBaseitem

@property (nonatomic, strong)NSString *description;
@property (nonatomic, strong)NSArray *items;

@property(nonatomic, copy)NSString *phone;
@property(nonatomic, copy)NSString *emergencyName;
@property(nonatomic, copy)NSString *emergencyPhoneNumber;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSNumber *teamSize;
@property(nonatomic, copy)NSString *token;

- (instancetype)initWithType:(userType)type name:(NSString *)name;

@end
