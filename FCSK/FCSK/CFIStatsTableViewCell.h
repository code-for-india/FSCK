//
//  CFIStatsTableViewCell.h
//  FCSK
//
//  Created by shashank on 10/05/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFIStatsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statsLabel;

@end
