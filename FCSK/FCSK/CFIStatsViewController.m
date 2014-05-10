//
//  CFIStatsViewController.m
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIStatsViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CFIStatsViewController ()
@property (weak, nonatomic) IBOutlet UIView *boothInfoView;
@property (weak, nonatomic) IBOutlet UILabel *boothName;
@property (weak, nonatomic) IBOutlet UILabel *boothAddress;
@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation CFIStatsViewController

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
    
    [self updateBoothInfoView];
    [self addMapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update Booth Info View
- (void)updateBoothInfoView
{
    
}

- (void)addMapView
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:12.96
                                                            longitude:77.56
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:self.mapContainerView.bounds camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    [self.mapContainerView addSubview:self.mapView];
    
    [self addMarkerAtLatitude:12.96 Longitude:77.56 title:@"Bangalore" snippet:@"Karnataka"];
    [self addCircleAtLatitude:12.96 Longitude:77.56 circleColor:[UIColor colorWithRed:65./255. green:91./255. blue:105./255. alpha:1.0f] fillColor:[UIColor colorWithRed:65./255. green:91./255. blue:105./255. alpha:0.6f] circleWidth:2 radius:50000 animate:YES];
}

- (void)addMarkerAtLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude title:(NSString *) title snippet:(NSString *)snippet
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = title;
    marker.icon = [UIImage imageNamed:@"ico_curr_loc"];
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.snippet = snippet;
    marker.map = self.mapView;
}

- (void)addCircleAtLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude circleColor:(UIColor *)color fillColor:(UIColor *)fillcolor circleWidth:(CGFloat)width radius:(CGFloat)radius animate:(BOOL)animate
{
    CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(latitude, longitude);
    GMSCircle *circle = [GMSCircle circleWithPosition:circleCenter radius:radius];
    circle.strokeColor = color;
    circle.fillColor = fillcolor;
    circle.strokeWidth = width;
    circle.map = self.mapView;
    
    //if(animate)
    //[self.locationCircleArray addObject:circle];
}
#pragma mark - Tap Animation
- (void)mapContainerTapped
{

}

@end
