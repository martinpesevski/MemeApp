//
//  MPAuthenticationManager.m
//  Betting
//
//  Created by Martin Peshevski on 5/5/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPAuthenticationManager.h"
#import "NetworkConstants.h"
#import "Constants.h"
#import "AFOAuth2Manager.h"

@interface MPAuthenticationManager ()

@end

@implementation MPAuthenticationManager

+ (MPAuthenticationManager *)sharedManager
{
    static MPAuthenticationManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[MPAuthenticationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    return sharedMyManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        [self.requestSerializer setValue:@"C3EE7018F61B2CD40F2" forHTTPHeaderField:@"X-Mam-Secret"];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [responseSerializer setRemovesKeysWithNullValues:YES];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        self.responseSerializer = responseSerializer;
        
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(successCompletion)completion
{
    NSDictionary *params = @{@"email": username,
                             @"password": password};
    [self GET:kAuthenticationEndpoint
   parameters:params
     progress:nil
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (!responseObject[@"authToken"]) {
              NSLog(@"EMPTY CREDENTIAL");
              completion(NO);
              return;
          }
          
          AFOAuthCredential *credential = [[AFOAuthCredential alloc] initWithOAuthToken:responseObject[@"authToken"] tokenType:@"bearer"];
          [AFOAuthCredential storeCredential:credential withIdentifier:kTokenIdentifier];
          [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGGED_IN_NOTIFICATION object:nil];
          completion(YES);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          completion(NO);
      }];
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
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kTokenIdentifier];
    return credential!=NULL;
}

- (void)signOut
{
    [AFOAuthCredential deleteCredentialWithIdentifier:kTokenIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGGED_OUT_NOTIFICATION object:nil];
}

@end
