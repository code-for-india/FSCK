//
//  KSXMLParser.h
//  Kratos
//
//  Created by Sanjeeva on 3/22/14.
//  Copyright (c) 2014 Kronos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSXMLParser : NSObject <NSXMLParserDelegate>

@property(strong,nonatomic)NSString *currentElement;
@property(strong,nonatomic)NSMutableDictionary *userDataDictionary;

-(void)parseXML:(NSString*)xmlString;
@end
