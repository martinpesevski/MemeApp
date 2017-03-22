//
//  Constants.h
//  Betting
//
//  Created by Martin Peshevski on 4/29/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define BASE_URL @"http://alpha.betapp.sorsix.com/"
//#define BASE_URL @"http://admin.fantrade.sorsix.com/"
#define kSocketNamespace @"/fixtures"
#define kTradeSocketNamespace @"/public/fixtures"
#define kSocketFixtureNamespace @"/fixtures/%@"
#define kSocketChatNamespace @"/leagues/%@"

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SELL_BET_NOTIFICATION @"SELL_BET_NOTIFICATION"
#define GOOGLE_LOGGED_IN_NOTIFICATION @"GOOGLE_LOGGED_IN_NOTIFICATION"
#define USER_UPDATED_NOTIFICATION @"USER_UPDATED_NOTIFICATION"
#define PROFILE_PICTURE_UPDATED_NOTIFICATION @"PROFILE_PICTURE_UPDATED_NOTIFICATION"
#define SHOW_PROFILE_NOTIFICATION @"SHOW_PROFILE_NOTIFICATION"
#define SHOW_TRADE_NOTIFICATION @"SHOW_TRADE_NOTIFICATION"
#define LOT_SIZE_CHANGED_NOTIFICATION @"LOT_SIZE_CHANGED_NOTIFICATION"
#define LEAGUE_CREATED_NOTIFICATION @"LEAGUE_CREATED_NOTIFICATION"
#define LEAGUE_CREATED_LEADERBOARD_NOTIFICATION @"LEAGUE_CREATED_LEADERBOARD_NOTIFICATION"
#define INTERNET_RECONNECTED_NOTIFICATION @"INTERNET_RECONNECTED_NOTIFICATION"

#define kLeftRightPadding 10
#define kTableViewPadding 20
#define kButtonHeight 30
#define kLoginButtonHeight 40
#define kTradeButtonHeight 50
#define kFloatingTextFieldHeight 50
#define kThumbnailHeightWidth 36
#define kLotSize @"kLotSize %@ %d"//fixture id, gameType

#define kTokenIdentifier @"accessToken"
#define kInfoTextIdentifier @"infoTextIdentifier"

typedef enum MPSportType {
    MPSportTypeRugby,
    MPSportTypeAFL,
    MPSportTypeCricket
} MPSportType;

#endif /* Constants_h */
