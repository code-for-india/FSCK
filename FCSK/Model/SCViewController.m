/*
 Copyright 2013 Scott Logic Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "SCViewController.h"
@import AVFoundation;
#import "SCShapeView.h"
#import "KSXMLParser.h"
#import "UIAlertView+Blocks.h"


@interface SCViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureVideoPreviewLayer *_previewLayer;
    SCShapeView *_boundingBox;
    NSTimer *_boxHideTimer;
    UILabel *_decodedMessage;
    BOOL isCaptured;
}
@property (strong,nonatomic)AVAudioPlayer* audioPlayer;
@property (strong, nonatomic) AVCaptureSession *captureSession;

@end

@implementation SCViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"SCAN QR CODE";
    // Create a new AVCaptureSession
    
}

-(void) startCapturing
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.captureSession = session;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    // Want the normal device
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if(input) {
        // Add the input to the session
        [session addInput:input];
    } else {
        NSLog(@"error: %@", error);
        return;
    }
    isCaptured= NO;
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // Have to add the output before setting metadata types
    [session addOutput:output];
    // What different things can we register to recognise?
    // We're only interested in QR Codes
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    // This VC is the delegate. Please call us on the main queue
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Display on screen
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.bounds =  CGRectMake(0, 0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds));
    _previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view.layer addSublayer:_previewLayer];
    
    _previewLayer.transform = CATransform3DIdentity;
    _previewLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI_2, 0, 0, 1);
    
    // Add the view to draw the bounding box for the UIView
    _boundingBox = [[SCShapeView alloc] initWithFrame:self.view.bounds];
    _boundingBox.backgroundColor = [UIColor clearColor];
    _boundingBox.hidden = YES;
    [self.view addSubview:_boundingBox];
    
    //    // Add a label to display the resultant message
    //    _decodedMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 75, CGRectGetWidth(self.view.bounds), 75)];
    //    _decodedMessage.numberOfLines = 0;
    //    _decodedMessage.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    //    _decodedMessage.textColor = [UIColor darkGrayColor];
    //    _decodedMessage.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:_decodedMessage];
    //
    // Start the AVSession running
    [session startRunning];

}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
   
   
    for (AVMetadataObject *metadata in metadataObjects) {
         if (!isCaptured) {
        if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            // Transform the meta-data coordinates to screen coords
            AVMetadataMachineReadableCodeObject *transformed = (AVMetadataMachineReadableCodeObject *)[_previewLayer transformedMetadataObjectForMetadataObject:metadata];
            // Update the frame on the _boundingBox view, and show it
            _boundingBox.frame = transformed.bounds;
            _boundingBox.hidden = NO;
            // Now convert the corners array into CGPoints in the coordinate system
            //  of the bounding box itself
            NSArray *translatedCorners = [self translatePoints:transformed.corners
                                                      fromView:self.view
                                                        toView:_boundingBox];
            
            // Set the corners array
            _boundingBox.corners = translatedCorners;
            
            // Update the view with the decoded text
            _decodedMessage.text = [transformed stringValue];
            NSString *xmlString =  [transformed stringValue];
            KSXMLParser* xmlParser = [[KSXMLParser alloc]init];
            [xmlParser parseXML:xmlString];
            
            NSLog(@"%@",xmlString);
            self.userDataDictionary = [[NSMutableDictionary alloc]initWithDictionary:xmlParser.userDataDictionary];
            
            NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
            NSURL *soundPathUrl = [NSURL URLWithString:soundPath];
            NSError* error;
            self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPathUrl error:&error];
            [self.audioPlayer play];
            isCaptured = YES;
            // Start the timer which will hide the overlay
            [self startOverlayHideTimer];
            
            [self.captureSession stopRunning];
            
           // NSLog(@"%@",xmlParser.userDataDictionary);
            
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Confirm Details" message:[NSString stringWithFormat:@"Name : %@ \n Token # : %@",self.userDataDictionary[@"name"],self.userDataDictionary[@"uid"]]
            cancelTitle:@"Try Again" cancelBlock:^(NSArray *collectedStrings)
            {
                [self startCapturing];
            }
            okTitle:@"Confirm" okBlock:^(NSArray *collectedStrings)
            {
                [_previewLayer removeFromSuperlayer];
                [_boundingBox removeFromSuperview];
                
                
                UITableView *tableView = [[UITableView alloc] init];
                tableView.frame =  self.view.frame;
                tableView.delegate = self;
                tableView.dataSource = self;
            
                [self.view addSubview:tableView];
                
            }];
            [alertView show];
            
            
            
            
//            [self.navigationController pushViewController:createAccountViewController animated:NO];
            
        }
    }
        
    }
}

#pragma mark - Utility Methods
- (void)startOverlayHideTimer
{
    // Cancel it if we're already running
    if(_boxHideTimer) {
        [_boxHideTimer invalidate];
    }
    
    // Restart it to hide the overlay when it fires
    _boxHideTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                     target:self
                                                   selector:@selector(removeBoundingBox:)
                                                   userInfo:nil
                                                    repeats:NO];
}

- (void)removeBoundingBox:(id)sender
{
    // Hide the box and remove the decoded text
    _boundingBox.hidden = YES;
    _decodedMessage.text = @"";
}

- (NSArray *)translatePoints:(NSArray *)points fromView:(UIView *)fromView toView:(UIView *)toView
{
    NSMutableArray *translatedPoints = [NSMutableArray new];

    // The points are provided in a dictionary with keys X and Y
    for (NSDictionary *point in points) {
        // Let's turn them into CGPoints
        CGPoint pointValue = CGPointMake([point[@"X"] floatValue], [point[@"Y"] floatValue]);
        // Now translate from one view to the other
        CGPoint translatedPoint = [fromView convertPoint:pointValue toView:toView];
        // Box them up and add to the array
        [translatedPoints addObject:[NSValue valueWithCGPoint:translatedPoint]];
    }
    
    return [translatedPoints copy];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Select Destination Booth";
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"neighbourBooths"] count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"boothCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"boothCell"];
        
    }
    
    NSDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"neighbourBooths"] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = dict[@"name"];
    cell.detailTextLabel.text = dict[@"id"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hasUserRegistered)
    {
        // call Update API
    }
    else
    {
        // call SignUP API
    }
    
    
    // send API To server indicating the next booth
    
    
    
    
    // on completion.
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}



@end
