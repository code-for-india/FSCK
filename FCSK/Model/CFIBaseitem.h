//
//  MPBaseitem.h
//  Museum Pilot
//
//  Created by Mahesh on 4/4/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFIBaseitem : NSObject

@property (nonatomic, assign)userType type;
@property (nonatomic, copy)NSString *name;

- (instancetype)initWithType:(userType)type name:(NSString *)name;

@end
