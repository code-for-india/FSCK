//
//  CFIRegisterUserViewController.m
//  FCSK
//
//  Created by shashank on 10/05/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIRegisterUserViewController.h"

#import "SCViewController.h"

@interface CFIRegisterUserViewController ()
{
    CGSize contentSize;
    CGPoint contentOffset;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *statefield;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *contactNameField;
@property (weak, nonatomic) IBOutlet UITextField *emergencyPhoneField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation CFIRegisterUserViewController

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"Scan Token" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(scanToken:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationController.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.title = @"Register User";
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    contentSize = self.scrollView.contentSize;
    contentOffset = self.scrollView.contentOffset;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.scrollView.frame;
    frame.size.height =768-352;
   
    self.scrollView.frame = frame;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width,416) ;
    if (textField.tag>1004)
    {
        [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.contentSize.height -self.scrollView.frame.size.height) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:contentOffset animated:YES];
    }
    
}

-(void)onKeyboardHide:(NSNotification*)notification
{
    CGRect frame = self.scrollView.frame;
    frame.size.height =768;
    self.scrollView.frame =frame;
    {
        self.scrollView.contentSize =  contentSize;
        [self.scrollView setContentOffset:contentOffset animated:YES];
    }
}

-(void) scanToken:(id)sender
{
    SCViewController* scanViewController = [[SCViewController alloc] initWithNibName:@"CFIScanViewController" bundle:nil];
    scanViewController.hasUserRegistered = NO;
    
    [self.navigationController pushViewController:scanViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
