//
//  Constants.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef Constants_h
#define Constants_h

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define USER_LOGGED_OUT_NOTIFICATION @"USER_LOGGED_OUT_NOTIFICATION"
#define USER_LOGGED_IN_NOTIFICATION @"USER_LOGGED_IN_NOTIFICATION"

#define kLeftRightPadding 10
#define kTableViewPadding 20
#define kMemePadding 30
#define kMemeTextfieldHeight 50
#define kButtonHeight 30
#define kLoginButtonHeight 40
#define kTradeButtonHeight 50
#define kFloatingTextFieldHeight 50
#define kThumbnailHeightWidth 36
#define kTabbarHeight 40

#define kTokenIdentifier @"memeGeneratorAccessToken"
#define kInfoTextIdentifier @"infoTextIdentifier"

typedef enum MPSportType {
    MPSportTypeRugby,
    MPSportTypeAFL,
    MPSportTypeCricket
} MPSportType;

typedef void(^resultCompletion)(id result, NSError *error);
typedef void(^imageCompletion)(UIImage *image);
typedef void(^stringCompletion)(NSString *string);

#endif /* Constants_h */
