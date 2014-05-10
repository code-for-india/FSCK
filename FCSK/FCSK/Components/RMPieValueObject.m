//
//  RMPieValueObject.m
//  RMPieChart
//
//  Created by Mahesh on 2/5/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "RMPieValueObject.h"

@implementation RMPieValueObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%@) (%@) (%@) (%@)",@(self.sourceStartAngle),@(self.sourceEndAngle),@(self.destinationStartAngle),@(self.destinationEndAngle)];
}

@end
