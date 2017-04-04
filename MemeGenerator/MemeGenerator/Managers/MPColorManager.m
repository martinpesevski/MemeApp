//
//  MPColorManager.m
//  Betting
//
//  Created by Martin Peshevski on 5/2/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPColorManager.h"

@implementation MPColorManager

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    if (!hexString) {
        return nil;
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    if ( [hexString rangeOfString:@"#"].location == 0 ){
        [scanner setScanLocation:1]; // bypass '#' character
    }
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)getBackgroundColor
{
    return [MPColorManager colorFromHexString:@"#838BFF"];
}

+ (UIColor *)getBackgroundLineColor
{
    return [UIColor grayColor];
}

+ (UIColor *)getBackgroundColorDarkGray
{
    return [MPColorManager colorFromHexString:@"#999999"];
}

+ (UIColor *)getFacebookColor
{
    return [MPColorManager colorFromHexString:@"#3b5998"];
}

+ (UIColor *)getSeparatorColor
{
    return [MPColorManager colorFromHexString:@"#EEEEEE"];
}

+ (UIColor *)getGreenColor
{
    return [MPColorManager colorFromHexString:@"#9BD370"];
}

+ (UIColor *)getRedColor
{
    return [MPColorManager colorFromHexString:@"#841E3C"];
}

+ (UIColor *)getLabelColorBlack
{
    return [UIColor blackColor];
}

+ (UIColor *)getLabelColorWhite
{
    return [UIColor whiteColor];
}

+ (UIColor *)getLabelColorGray
{
    return [MPColorManager colorFromHexString:@"#999999"];
}

+ (UIColor *)getLabelColorGreen
{
    return [MPColorManager getGreenColor];
}

+ (UIColor *)getLabelColorRed
{
    return [UIColor redColor];
}

+ (UIColor *)getNavigationBarColor
{
    return [MPColorManager colorFromHexString:@"#A0D48"];
}

+ (UIColor *)getTabBarColor
{
    return [MPColorManager colorFromHexString:@"#37474F"];
}

@end
