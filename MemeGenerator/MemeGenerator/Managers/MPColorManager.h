//
//  MPColorManager.h
//  Betting
//
//  Created by Martin Peshevski on 5/2/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPColorManager : NSObject

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)getBackgroundColor;
+ (UIColor *)getBackgroundColorDarkGray;

+ (UIColor *)getFacebookColor;
+ (UIColor *)getSeparatorColor;
+ (UIColor *)getBackgroundLineColor;
+ (UIColor *)getGreenColor;
+ (UIColor *)getRedColor;

+ (UIColor *)getLabelColorBlack;
+ (UIColor *)getLabelColorWhite;
+ (UIColor *)getLabelColorGray;
+ (UIColor *)getLabelColorGreen;
+ (UIColor *)getLabelColorRed;

+ (UIColor *)getNavigationBarColor;
+ (UIColor *)getTabBarColor;

@end
