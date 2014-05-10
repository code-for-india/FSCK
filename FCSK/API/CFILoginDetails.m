//
//  MPMuseumItemDetails.m
//  Museum Pilot
//
//  Created by Mahesh on 4/5/14.
//  Copyright (c) 2014 YML. All rights reserved.
//

#import "CFILoginDetails.h"

#import "<#header#>"

@implementation CFILoginDetails

- (void)getMuseumDataWithUDID:(NSString *)UDID ID:(NSString *)ID majorId:(NSString *)majorID minorID:(NSString *)minorID callback:(responseCallBack)callback
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // this is a POST request
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",baseURL,@"/getArticleDetails.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *bodyData = [NSString stringWithFormat:@"uuid=%@&major=%@&minor=%@",UDID,majorID,minorID];
    [request setHTTPBody:[bodyData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if([(NSHTTPURLResponse *)response statusCode] == 200)
        {
            // success
            //NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            callback(@"",nil, YES);
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
-(void) loginWithUserName:(NSString *)username passWord:(NSString *)password callBack:(responseCallBack) callBack
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // this is a POST request
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",baseURL,@"/getArticleDetails.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *dict = @{@"username":username,@"password":password};

    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dict options:NSUTF8StringEncoding error:nil] ];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if([(NSHTTPURLResponse *)response statusCode] == 200)
        {
            // success
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            
            if (callBack)
            {
                callBack(@"",nil,YES);
            }
            
        }
        else
        {
            // error
            // success
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            callBack(dictionary, error, NO);
        }
    }];
    
    [dataTask resume];

}


#pragma mark - Parse Item
/*- (void)parseItemDetails:(NSDictionary *)data item:(MPMuseumItem *)item
{
    NSString *description = data[@"description"];
    NSURL *imageURL = [NSURL URLWithString:data[@"image_url"]];
    
    item.noteItems = [self noteFromData:data[@"notes"]];
    item.nearByItems = [self nearByFromData:data[@"nearby"]];
    
    item.description = description;
    item.imgURL = imageURL;
}

- (NSArray *)noteFromData:(NSArray *)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in data)
    {
        [array addObject:[self note:dict]];
    }
    
    return array;
}

- (MPMuseumNotes *)note:(NSDictionary *)dictionary
{
    NSString *ID = dictionary[@"id"];
    NSString *name = dictionary[@"name"];
    NSString *aid = dictionary[@"aid"];
    NSString *notes = dictionary[@"notes"];
    NSDate *date = [NSDate date];
    
    
    MPMuseumNotes *note = [[MPMuseumNotes alloc]initWithID:ID name:name];
    note.aid = aid;
    note.notes = notes;
    note.time = [NSString stringWithFormat:@"%@",date];
    
    return note;
}

- (NSArray *)nearByFromData:(NSArray *)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in data)
    {
        [array addObject:[self nearBy:dict]];
    }
    
    return array;
}

- (MPMuseumNearBy *)nearBy:(NSDictionary *)dictionary
{
    NSString *ID = dictionary[@"id"];
    NSString *uuid = dictionary[@"name"];
    NSString *major = dictionary[@"aid"];
    NSString *minor = dictionary[@"notes"];
    NSString *title = dictionary[@"title"];
    NSString *note = dictionary[@"note"];
    
    
    MPMuseumNearBy *nearBy = [[MPMuseumNearBy alloc]initWithID:ID name:title];
    nearBy.UDID = uuid;
    nearBy.majorID = major;
    nearBy.minorID = minor;
    nearBy.description = note;
    
    return nearBy;
}*/


@end
