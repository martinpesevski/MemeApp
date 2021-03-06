//
//  MPAuthenticationManager.h
//  Betting
//
//  Created by Martin Peshevski on 5/5/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPNetworkManager.h"
#import "Constants.h"

@interface MPAuthenticationManager : AFHTTPSessionManager

+ (MPAuthenticationManager *)sharedManager;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(successCompletion)completion;

- (void)loginWithFbToken:(NSString *)token username:(NSString *)username completion:(resultCompletion)completion;

- (void)loginWithToken:(NSString *)token completion:(successCompletion)completion;

- (BOOL)isLoggedIn;
- (void)signOut;
- (void)refreshTokenWithCompletion:(successCompletion)completion;

@end
