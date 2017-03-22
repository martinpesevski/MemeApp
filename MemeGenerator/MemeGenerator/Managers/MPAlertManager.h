//
//  MPAlertManager.h
//  Betting
//
//  Created by Martin Peshevski on 5/13/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MPSimpleBlock)(void);
typedef void (^MPValueBlock)(int amount);
typedef void (^MPArrayBlock)(NSArray *resultArray);

@interface MPAlertManager : NSObject

+ (void)showAlertMessage:(NSString*)message;
+ (void)showAlertMessage:(NSString*)message withOKblock:(MPSimpleBlock)callbackBlock;
+ (void)showAlertMessage:(NSString *)message withOKblock:(MPSimpleBlock)callbackBlock hasCancelButton:(BOOL)hasCancelButton;

+ (void)showActionSheetWithTitles:(NSArray *)titles
                           blocks:(NSArray *)blocks
                       sourceView:(UIView *)sourceView
                            title:(NSString *)title;

@end
