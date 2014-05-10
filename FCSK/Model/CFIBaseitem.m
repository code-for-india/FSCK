//
//  MPBaseitem.m
//  Museum Pilot
//
//  Created by Mahesh on 4/4/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import "CFIBaseitem.h"

@implementation CFIBaseitem

- (instancetype)initWithType:(userType)type name:(NSString *)name
{
    self = [super init];
    if(self)
    {
        _type = type;
        _name = name;
    }
    
    return self;
}

- (instancetype)init
{
    self = [self initWithType:kUsertypeIndividual name:@""];
    if(self)
    {
    
    }
    
    return self;
}

@end
