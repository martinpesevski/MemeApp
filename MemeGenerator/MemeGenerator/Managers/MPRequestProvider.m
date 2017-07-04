//
//  MPRequestProvider.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/10/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPRequestProvider.h"
#import "MPNetworkManager.h"
#import "NetworkConstants.h"
#import "AFOAuth2Manager.h"

@implementation MPRequestProvider

+ (MPRequestProvider *)sharedInstance
    {
        static MPRequestProvider *sharedProvider = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedProvider = [[MPRequestProvider alloc] init];
        });
        return sharedProvider;
}

- (void)registerWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password completion:(resultCompletion)completion
{
    NSDictionary *params = @{@"email":email,
                             @"username":username,
                             @"password":password,
                             };
    
    [[MPNetworkManager sharedManager] POST:kRegisterEndpoint
                                parameters:params
                                  progress:nil
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSArray *errorsArray = responseObject[@"errors"];
         if (errorsArray && errorsArray.count>0) {
             NSError *error = [NSError errorWithDomain:errorsArray[0] code:100 userInfo:nil];
             completion(nil, error);
         } else {
             AFOAuthCredential *credential = [[AFOAuthCredential alloc] initWithOAuthToken:responseObject[@"authToken"] tokenType:@"bearer"];
             [AFOAuthCredential storeCredential:credential withIdentifier:kTokenIdentifier];
             [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGGED_IN_NOTIFICATION object:nil];
             completion (responseObject, nil);
         }
     }
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR posting meme ====\n%@",error.userInfo);
         completion(nil, error);
     }];
}

- (void)getMemesWithCompletion:(resultCompletion)completion
{
    [[MPNetworkManager sharedManager] GET:kGetMemesEndpoint
                                parameters:nil
                                  progress:nil
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         completion (responseObject, nil);
     }
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR getting templates ====\n%@",error.userInfo);
         completion(nil, error);
     }];
}

- (void)checkUsernameAvailable:(NSString *)username completion:(successCompletion)completion
{
    NSDictionary *paramsDictionary = @{@"username":username};
    
    [[MPNetworkManager sharedManager] GET:kCheckAccountEndpoint
                               parameters:paramsDictionary
                                 progress:nil
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if ([responseObject[@"username"] isEqualToString:@"available"]) {
             completion(YES);
         }
         completion (NO);
     }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR checking account ====\n%@",error.userInfo);
         completion(NO);
     }];
}

- (void)getUserMemesWithCompletion:(resultCompletion)completion
{
    [[MPNetworkManager sharedManager] GET:kGetUserMemesEndpoint
                               parameters:nil
                                 progress:nil
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString *errorString = responseObject[@"error"];
         if (errorString) {
             NSError *error = [NSError errorWithDomain:errorString code:100 userInfo:nil];
             completion(nil, error);
         } else {
             completion (responseObject, nil);
         }
     }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR getting user memes ====\n%@",error.userInfo);
         completion(nil, error);
     }];
}

- (void)postMeme:(MPMeme *)meme completion:(resultCompletion)completion
{
    if (!(meme.topText || meme.bottomText) ||
        !meme.name ||
        !meme.image) {
        completion(nil, nil);
        return;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(meme.image, 1.0);
    
    NSDictionary *params = @{@"topText":meme.topText,
                             @"bottomText":meme.bottomText,
                             @"title":meme.name,
                             @"imageData":[imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed],
                             @"imageType":@"jpg",
                             @"characterId":@0
                             };
    
    [[MPNetworkManager sharedManager] POST:kPostMemeEndpoint
                                parameters:params
                                  progress:nil
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         completion (responseObject, nil);
     }
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR posting meme ====\n%@",error.userInfo);
         completion(nil, error);
     }];
}

- (void)updatePrivacyForMeme:(MPMeme *)meme completion:(resultCompletion)completion
{
    if (!meme.memeID) {
        completion(nil, nil);
        return;
    }
    
    NSDictionary *params = @{@"memeId":meme.memeID,
                             @"privacy":[meme stringFromMemePrivacy:meme.privacy]
                             };
    
    [[MPNetworkManager sharedManager] PUT:kUpdateMemeEndpoint
                               parameters:params
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         completion (responseObject, nil);
     }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR updating meme privacy ====\n%@",error.userInfo);
         completion(nil, error);
     }];
}

@end
