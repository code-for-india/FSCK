//
//  KSCreateAccountViewController.m
//  Kratos
//
//  Created by Sanjeeva on 3/22/14.
//  Copyright (c) 2014 Kronos. All rights reserved.
//

#import "KSCreateAccountViewController.h"

@interface KSCreateAccountViewController (){
    CGFloat contentOffset;
    BOOL isCouncillor;
}

@end

@implementation KSCreateAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.topItem.title = @"SIGNUP";
    
    self.labelName.text = self.stringName;
    self.labelUid.text = self.stringUid;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    contentOffset = self.scrollViewSignUp.contentOffset.y;
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [allViewControllers removeObjectAtIndex:1];
    self.navigationController.viewControllers = allViewControllers;
    isCouncillor = NO;
}
- (IBAction)isCouncillorChanged:(id)sender {
    isCouncillor = !isCouncillor;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag>1005) {
        [self.scrollViewSignUp setContentOffset:CGPointMake(0,  150)];
    }else{
        [self.scrollViewSignUp setContentOffset:CGPointMake(0,  contentOffset)];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    UITextField *nextTextField = (UITextField *) [self.view viewWithTag:textField.tag+1];
    
    if (nextTextField &&[nextTextField isKindOfClass:[UITextField class]])
    {
        [nextTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self.scrollViewSignUp setContentOffset:CGPointMake(0,contentOffset)];
    }
    return YES;
}


- (IBAction)createAccountTapped:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
