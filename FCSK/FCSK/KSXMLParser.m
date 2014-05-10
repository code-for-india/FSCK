//
//  KSXMLParser.m
//  Kratos
//
//  Created by Sanjeeva on 3/22/14.
//  Copyright (c) 2014 Kronos. All rights reserved.
//

#import "KSXMLParser.h"

@implementation KSXMLParser
-(void)parseXML:(NSString*)xmlString {
//    NSString *xmlString =
    
    NSData *xmlData = [xmlString dataUsingEncoding:NSASCIIStringEncoding];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    
    [xmlParser setDelegate:self];
    
    [xmlParser parse];
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    NSLog(@"Element started %@",elementName);
    if ([elementName  isEqual: @"PrintLetterBarcodeData"]) {
        _userDataDictionary = [[NSMutableDictionary alloc]initWithDictionary:attributeDict];
    }
    self.currentElement=elementName;
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    NSLog(@"Element ended %@",elementName);
    
    self.currentElement=@"";
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
   
//    if([self.currentElement isEqualToString:@"VideoListResult"]){
//        // NSLog(@"The characters are %@",string);
//        
//        id data = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSASCIIStringEncoding] options:0 error:nil];
//        
//        
//        NSLog(@"The page numbers are %@",[[[data valueForKey:@"List"] objectAtIndex:0] valueForKey:@"PageNumber"]);
//        
//        
//    }
}
@end
