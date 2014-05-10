//
//  CFISignInViewController.m
//  FCSK
//
//  Created by shashank on 10/05/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFISignInViewController.h"

@interface CFISignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signIN:(id)sender;

@end

@implementation CFISignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void) loginWithUsername:(NSString *)username withPassword:(NSString *)password
{
    // Send API from here
    
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIN:(id)sender {
    [self loginWithUsername:self.usernameField.text withPassword:self.passwordField.text];
}
@end
