//
//  CFIStatsViewController.h
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFIBooth.h"

@interface CFIStatsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) CFIBooth *booth;

- (void)loadBoothDetaisl:(NSString *)ID;

@end
