//
//  MPAuthenticationManager.m
//  Betting
//
//  Created by Martin Peshevski on 5/5/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPAuthenticationManager.h"
#import "Constants.h"
//#import <AFOAuth2Manager/AFOAuth2Manager.h>

@interface MPAuthenticationManager ()

//@property (nonatomic, strong) AFOAuth2Manager *OAuth2Manager;

@end

@implementation MPAuthenticationManager

+ (MPAuthenticationManager *)sharedManager
{
    static MPAuthenticationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[MPAuthenticationManager alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];

//        self.OAuth2Manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL
//                                                             clientID:@"betapp"
//                                                               secret:@"betapp-secret"];
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(successCompletion)completion
{
    completion(YES);
//    [self.OAuth2Manager authenticateUsingOAuthWithURLString:kTokenEndpoint
//                                              username:username
//                                              password:password
//                                                 scope:nil
//                                               success:^(AFOAuthCredential *credential) {
//                                                   if (credential) {
//                                                       [AFOAuthCredential storeCredential:credential withIdentifier:kTokenIdentifier];
//                                                       completion(YES);
//                                                   } else {
//                                                       completion(NO);
//                                                       NSLog(@"EMPTY CREDENTIAL");
//                                                   }
//                                               }
//                                               failure:^(NSError *error) {
//                                                   completion(NO);
//                                                   NSLog(@"Error: %@", error);
//                                               }];
}

- (void)loginWithToken:(NSString *)token completion:(successCompletion)completion
{
    completion(YES);
//    NSDictionary *params = @{@"accessToken": token};
//    [self.OAuth2Manager authenticateUsingOAuthWithURLString:kTokenEndpoint
//                                                 parameters:params
//                                                    success:^(AFOAuthCredential * _Nonnull credential)
//     {
//         if (credential) {
//             [AFOAuthCredential storeCredential:credential withIdentifier:kTokenIdentifier];
//             completion(YES);
//         } else {
//             completion(NO);
//             NSLog(@"EMPTY CREDENTIAL");
//         }
//     }
//                                                    failure:^(NSError * _Nonnull error)
//     {
//         completion(NO);
//         NSLog(@"Error: %@", error);
//     }];
}

- (void)refreshTokenWithCompletion:(successCompletion)completion
{
    completion(YES);
//    if ([self isLoggedIn]) {
//            AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kTokenIdentifier];
//        
//        [self.OAuth2Manager authenticateUsingOAuthWithURLString:kTokenEndpoint
//                                                   refreshToken:credential.refreshToken
//                                                        success:^(AFOAuthCredential * _Nonnull credential)
//        {
//            [AFOAuthCredential storeCredential:credential withIdentifier:kTokenIdentifier];
//            NSLog(@"REFRESHED TOKEN");
//            completion(YES);
//        } failure:^(NSError * _Nonnull error) {
//            completion(NO);
//        }];
//    }
}


- (BOOL)isLoggedIn
{
//    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kTokenIdentifier];
//    return credential!=NULL;
    
    return NO;
}

- (void)signOut
{
//    [AFOAuthCredential deleteCredentialWithIdentifier:kTokenIdentifier];
}

@end
