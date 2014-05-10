//
//  CFIGetRegionCheckPosts.m
//  FCSK
//
//  Created by Mahesh on 5/10/14.
//  Copyright (c) 2014 Mahesh. All rights reserved.
//

#import "CFIGetRegionCheckPosts.h"
#import "CFIBooth.h"

@implementation CFIGetRegionCheckPosts

- (void)getAllCheckPostForTheRegion:(responseCallBack)callback
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // this is a POST request
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",baseURL,@"getAllItems.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if([(NSHTTPURLResponse *)response statusCode] == 200)
        {
            // success
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            callback([self parseRegionCheckposts:dictionary], nil, YES);
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

- (NSArray *)parseRegionCheckposts:(NSDictionary *)data
{
    NSArray *array  = data[@"data"];
    __block NSMutableArray *boothArray = [NSMutableArray arrayWithCapacity:data.count];
    
    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        CFIBooth *booth = [[CFIBooth alloc]init];
        booth.latitude = obj[@"latitude"];
        booth.longitude = obj[@"longitude"];
        booth.ID = obj[@"ID"];
        
        [boothArray addObject:booth];
    }];
    
    return boothArray;
}

@end
