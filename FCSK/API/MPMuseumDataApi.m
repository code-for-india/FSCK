//
//  MPMuseumDataApi.m
//  Museum Pilot
//
//  Created by Mahesh on 4/5/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import "MPMuseumDataApi.h"

@implementation MPMuseumDataApi

- (void)getMuseumDataWithUDID:(NSString *)UDID majorId:(NSString *)majorID minorID:(NSString *)minorID callback:(responseCallBack)callback
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // this is a POST request
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",baseURL,@"getAllItems.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *bodyData = [NSString stringWithFormat:@"uuid=%@&major=%@&minor=%@",UDID,majorID,minorID];
    [request setHTTPBody:[bodyData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //typeof(self) __weak weakself = self;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if([(NSHTTPURLResponse *)response statusCode] == 200)
        {
            // success
            //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            callback(nil, nil, YES);
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

#pragma mark - Parse Museum Data
/*- (MPMuseumInfo *)parseData:(NSDictionary *)dictionary
{
    NSString *ID = dictionary[@"id"];
    NSString *UDID = dictionary[@"uuid"];
    NSString *majorID = dictionary[@"major"];
    NSString *minorID = dictionary[@"minor"];
    NSString *name = dictionary[@"title"];
    NSString *description = dictionary[@"description"];
    NSString *imgURL = dictionary[@"image_url"];
    
    MPMuseum *museum = [[MPMuseum alloc]initWithID:ID UDID:UDID name:name description:description items:[self museumItemsWithArticles:dictionary[@"articles"]]];
    museum.majorID = majorID;
    museum.minorID = minorID;
    museum.imgURL = [NSURL URLWithString:imgURL];
    
    MPMuseumInfo *info = [[MPMuseumInfo alloc]initWithMuseums:@[museum]];
    return info;
}



- (NSArray *)museumItemsWithArticles:(NSArray *)articleData
{
    NSMutableArray *articleCollection = [NSMutableArray array];
    for (NSDictionary *article in articleData)
    {
        [articleCollection addObject:[self museumItemWithData:article]];
    }
    
    return articleCollection;
}

- (MPMuseumItem *)museumItemWithData:(NSDictionary *)data
{
    NSString *ID = data[@"id"];
    NSString *UDID = data[@"uuid"];
    NSString *majorID = data[@"major"];
    NSString *minorID = data[@"minor"];
    NSString *name = data[@"title"];
    NSString *summary = data[@"summary"];
    NSString *section = data[@"section"];
    NSString *imgURL = data[@"image_url"];
    
    MPMuseumItem *item = [[MPMuseumItem alloc]initWithID:ID name:name section:section summary:summary];
    item.UDID = UDID;
    item.majorID = majorID;
    item.minorID = minorID;
    item.imgURL = [NSURL URLWithString:imgURL];
    
    return item;
}*/

@end
