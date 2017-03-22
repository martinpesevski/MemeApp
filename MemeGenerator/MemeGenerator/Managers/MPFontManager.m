//
//  MPFontManager.m
//  Betting
//
//  Created by Martin Peshevski on 5/7/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPFontManager.h"

@implementation MPFontManager

+ (UIFont *)getTabBarFont
{
    return [UIFont systemFontOfSize:10];
}

+ (UIFont *)getSmallFont
{
    return [UIFont systemFontOfSize:8];
}

+ (UIFont *)getTitleLabelFont
{
    return [UIFont boldSystemFontOfSize:16];
}

+ (UIFont *)getTitleLabelNormalFont
{
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)getDescriptionLabelBoldFont
{
    return [UIFont boldSystemFontOfSize:12];
}

+ (UIFont *)getDescriptionLabelNormalFont
{
    return [UIFont systemFontOfSize:12];
}

+ (UIFont *)getDescriptionLabelLargeFont
{
    return [UIFont systemFontOfSize:13];
}

+ (UIFont *)getDescriptionLabelLargeBoldFont
{
    return [UIFont boldSystemFontOfSize:13];
}

+ (UIFont *)getLargeFont
{
    return [UIFont systemFontOfSize:25];
}

+ (NSString *)formattedStringFromNumber:(NSNumber *)number
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted = [formatter stringFromNumber:number];
    return formatted;
}

+ (NSNumber *)numberFromFormattedString:(NSString *)string
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSNumber *formatted = [formatter numberFromString:string];
    return formatted;
}

@end
