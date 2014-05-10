//
//  CFIGetRegionCheckPosts.h
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIApi.h"

@interface CFIGetRegionCheckPosts : CFIApi

- (void)getAllCheckPostForTheRegion:(responseCallBack)callback;

@end
