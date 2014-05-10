//
//  CFIGetRoute.m
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIGetRoute.h"
#import <CoreLocation/CoreLocation.h>

@implementation CFIGetRoute

- (void)getRouteFrom:(CFILocation *)from to:(CFILocation *)to callback:(responseCallBack)callback
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // this is a POST request
    // http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true&mode=%@
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=Hubli&destination=Bangalore&sensor=true&key=%@",@"AIzaSyDXMaoTbM3YmtQBnGHqIKeE5lv9nksV2vM"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    //typeof(self) __weak weakself = self;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if([(NSHTTPURLResponse *)response statusCode] == 200)
        {
            // success
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            callback([self parseRoute:dictionary], nil, YES);
        }
        else
        {
            // error
            // success
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            callback(dictionary, error, NO);
        }
    }];
    
    [dataTask resume];
    
}

#pragma mark - Parse Route
- (NSString *)parseRoute:(NSDictionary *)dictionary
{
    NSArray *routes = dictionary[@"routes"];
    NSDictionary *path = [[routes objectAtIndex:0] objectForKey:@"overview_polyline"];
    return path[@"points"];
}


@end
