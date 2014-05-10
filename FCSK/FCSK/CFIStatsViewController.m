//
//  CFIStatsViewController.m
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIStatsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CFIShareRegionInfo.h"
#import "CFIStatsTableViewCell.h"
#import "RMPieChart.h"


@interface CFIStatsViewController ()<RMPieChartDelegate,RMPieChartDataSource>
@property (weak, nonatomic) IBOutlet UIView *boothInfoView;
@property (weak, nonatomic) IBOutlet UILabel *boothName;
@property (weak, nonatomic) IBOutlet UILabel *boothAddress;

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;
@property (strong, nonatomic) GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *mapTableView;
@property (strong, nonatomic) NSArray *neighbourBoothsArray;
@property (weak, nonatomic) IBOutlet UIView *charContainerView;
@property (strong, nonatomic) RMPieChart *pieChart;
@property (strong, nonatomic) NSMutableArray *pieChartData;
@property (weak, nonatomic) IBOutlet UIView *srView;
@property (weak, nonatomic) IBOutlet UILabel *SRLabel;
@property (weak, nonatomic) IBOutlet UIView *wview;
@property (weak, nonatomic) IBOutlet UILabel *wLabel;
@property (weak, nonatomic) IBOutlet UIView *mview;
@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@property (weak, nonatomic) IBOutlet UIView *cview;
@property (weak, nonatomic) IBOutlet UILabel *cLabel;

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
   
    NSMutableArray *array = [NSMutableArray arrayWithArray: [CFIShareRegionInfo sharedInstance].currentRegion.booths];
    [array removeObject:self.booth];
    
    self.pieChartData = [NSMutableArray array];
    [self loadPieChart];
    
    self.neighbourBoothsArray = array;
    
    self.title = @"Statistics";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

#pragma mark - Load PieChart
- (void)loadPieChart
{
    self.pieChart = [[RMPieChart alloc]initWithFrame:self.charContainerView.bounds];
    self.pieChart.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.pieChart.backgroundColor = [UIColor clearColor];
    self.pieChart.chartBackgroundColor = [UIColor clearColor];
    self.pieChart.radiusPercent = 0.3;
    self.pieChart.datasource = self;
    self.pieChart.delegate = self;
    [self.charContainerView addSubview:self.pieChart];
    
    [self.pieChart loadChart];
    
    self.srView.backgroundColor = [UIColor colorWithHue:90/360.0 saturation:1 brightness:1 alpha:1];
    self.wview.backgroundColor = [UIColor colorWithHue:180/360.0 saturation:1 brightness:1 alpha:1];
    self.mview.backgroundColor = [UIColor colorWithHue:270/360.0 saturation:1 brightness:1 alpha:1];
    self.cview.backgroundColor = [UIColor colorWithHue:360/360.0 saturation:1 brightness:1 alpha:1];
    
    [self.pieChartData addObject:@(90)];
    [self.pieChartData addObject:@(90)];
    [self.pieChartData addObject:@(90)];
    [self.pieChartData addObject:@(90)];
    
    [self.pieChart reloadChart];
}

- (NSUInteger)numberOfSlicesInChartView:(id)chartView
{
    return self.pieChartData.count;
}

- (CGFloat)percentOfTotalValueOfSliceAtIndexpath:(NSIndexPath *)indexPath chart:(id)chartView
{
    return [self.pieChartData[indexPath.row] floatValue];
}

- (UIColor *)colorForSliceAtIndexPath:(NSIndexPath *)indexPath slice:(id)pieSlice
{
    return [UIColor colorWithHue:((90+(indexPath.row *90))/360.0f) saturation:1 brightness:1 alpha:1.0f];
}

#pragma mark - Tap Animation
- (void)mapContainerTapped
{
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.neighbourBoothsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFIBooth *booth = self.neighbourBoothsArray[indexPath.row];
    
    CFIStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statsCell"];
    
    if (!cell)
    {
        cell = [[CFIStatsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"statsCell"];
    }
    
    cell.nameLabel.text = booth.name;
    
    cell.coordinateLabel.text = [NSString stringWithFormat:@"lat: %@ , long: %@",booth.latitude , booth.longitude];
    cell.statsLabel.text = [NSString stringWithFormat:@"%@",booth.travellerDensity];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
