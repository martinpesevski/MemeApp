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
    return [UIFont fontWithName:@"HelveticaNeue" size:10];
}

+ (UIFont *)getSmallFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:8];
}

+ (UIFont *)getTitleLabelFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:16];
}

+ (UIFont *)getTitleLabelNormalFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:16];
}

+ (UIFont *)getDescriptionLabelBoldFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:12];
}

+ (UIFont *)getDescriptionLabelNormalFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:12];
}

+ (UIFont *)getDescriptionLabelLargeFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:13];
}

+ (UIFont *)getDescriptionLabelLargeBoldFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:13];
}

+ (UIFont *)getLargeFont
{
    return [UIFont fontWithName:@"HelveticaNeue" size:25];
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
