//
//  CFIGetCheckPostDetails.m
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIGetCheckPostDetails.h"
#import "CFIBooth.h"
#import "CFICurrentBooth.h"

@implementation CFIGetCheckPostDetails

- (void)getCheckPostDetailsWithId:(NSString *)ID callback:(responseCallBack)callback
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // this is a POST request
    NSString *urlString = [NSString stringWithFormat:@"%@checkpost?id=%@",baseURL,ID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if([(NSHTTPURLResponse *)response statusCode] == 200)
        {
            // success
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            callback([self parseData:dictionary ID:ID], nil, YES);
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

- (CFIBooth *)parseData:(NSDictionary *)dict ID:(NSString *)ID
{
    CFIBooth *booth = [[CFIBooth alloc]init];
    booth.latitude = dict[@"Latitude"];
    booth.longitude = dict[@"Longitude"];
    booth.ID = dict[@"PostId"];
    booth.name = dict[@"Name"];

    return booth;
}

@end
