//
//  UIAlertView+Blocks.h
//  FCSK
//
//  Created by Shashank.
//  Copyright (c) 2014 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIAlertView (Blocks) <UIAlertViewDelegate>

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)(NSArray *collectedStrings))cancelBlock okTitle:(NSString *)okTitle okBlock:(void (^)(NSArray *collectedStrings))okBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertViewStyle)style cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)(NSArray *collectedStrings))cancelBlock okTitle:(NSString *)okTitle okBlock:(void (^)(NSArray *collectedStrings))okBlock;

+ (void)quickAlertWithTitle:(NSString*)title message:(NSString*)message;

@end
