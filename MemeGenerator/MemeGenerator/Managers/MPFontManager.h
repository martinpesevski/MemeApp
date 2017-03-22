//
//  MPFontManager.h
//  Betting
//
//  Created by Martin Peshevski on 5/7/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPFontManager : NSObject

+ (UIFont *)getTabBarFont;
+ (UIFont *)getSmallFont;
+ (UIFont *)getTitleLabelFont;
+ (UIFont *)getTitleLabelNormalFont;
+ (UIFont *)getDescriptionLabelBoldFont;
+ (UIFont *)getDescriptionLabelNormalFont;
+ (UIFont *)getDescriptionLabelLargeFont;
+ (UIFont *)getDescriptionLabelLargeBoldFont;
+ (UIFont *)getLargeFont;
+ (NSString *)formattedStringFromNumber:(NSNumber *)number;
+ (NSNumber *)numberFromFormattedString:(NSString *)string;

@end
