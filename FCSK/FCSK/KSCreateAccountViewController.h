//
//  KSCreateAccountViewController.h
//  Kratos
//
//  Created by Sanjeeva on 3/22/14.
//  Copyright (c) 2014 Kronos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSCreateAccountViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewSignUp;

@property (strong, nonatomic) IBOutlet UITextField *labelName;
@property (strong, nonatomic) IBOutlet UITextField *labelUid;
@property(strong,nonatomic) NSString *stringName;
@property(strong,nonatomic) NSString *stringUid;

@end
