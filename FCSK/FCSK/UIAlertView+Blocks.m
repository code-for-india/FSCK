//
//  UIAlertView+Blocks.m
//  FCSK
//
//  Created by Shashank
//  Copyright (c) 2014 Shashank. All rights reserved.
//



#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>


static const NSInteger buttonCancel = 0;
static const NSInteger buttonOK = 1;
static void *cancelBlockKey;
static void *okBlockKey;


@implementation UIAlertView (Blocks)


#pragma - creation

+ (void)quickAlertWithTitle:(NSString*)title message:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:title message:message cancelTitle:@"OK" cancelBlock:nil okTitle:nil okBlock:nil] show];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)(NSArray *collectedStrings))cancelBlock okTitle:(NSString *)okTitle okBlock:(void (^)(NSArray *collectedStrings))okBlock {
    return [self initWithTitle:title message:message style:UIAlertViewStyleDefault cancelTitle:cancelTitle cancelBlock:cancelBlock okTitle:okTitle okBlock:okBlock];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message style:(UIAlertViewStyle)style cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)(NSArray *collectedStrings))cancelBlock okTitle:(NSString *)okTitle okBlock:(void (^)(NSArray *collectedStrings))okBlock {
    if (okTitle) {
        self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:okTitle, nil];
    } else {
        self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
    }
    
    if (self) {
        self.alertViewStyle = style;
        
        // Can't add properties in a category (maybe I should have used a subclass?)
        objc_setAssociatedObject(self, &cancelBlockKey, cancelBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &okBlockKey, okBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return self;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSArray *collectedStrings = nil;
    switch (alertView.alertViewStyle) {
        case UIAlertViewStyleDefault:
            // no-op
            break;
            
        case UIAlertViewStylePlainTextInput:
        case UIAlertViewStyleSecureTextInput:
            collectedStrings = @[[alertView textFieldAtIndex:0].text];
            break;
            
        case UIAlertViewStyleLoginAndPasswordInput:
            collectedStrings = @[[alertView textFieldAtIndex:0].text, [alertView textFieldAtIndex:1].text];
            break;
    }

    switch (buttonIndex) {
        case buttonCancel:
        {
            void (^cancelBlock)(NSArray *collectedStrings) = objc_getAssociatedObject(self, &cancelBlockKey);
            if (cancelBlock) cancelBlock(collectedStrings);
        }
            break;
            
        case buttonOK:
        {
            void (^okBlock)(NSArray *collectedStrings) = objc_getAssociatedObject(self, &okBlockKey);
            if (okBlock) okBlock(collectedStrings);
        }
            
        default: // ???
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //DLog(@"^^^ alertView:didDismissWithButtonIndex: %d", buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    //DLog(@"^^^ alertView:willDismissWithButtonIndex: %d", buttonIndex);
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    //DLog(@"^^^ alertViewCancel:");
}
@end
