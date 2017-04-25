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

- (void)checkAccountWithCompletion:(resultCompletion)completion
{
    NSDictionary *paramsDictionary = @{@"email":@"martin.the.don@hotmail.com"};
    
    [[MPNetworkManager sharedManager] GET:kCheckAccountEndpoint
                               parameters:paramsDictionary
                                 progress:nil
                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         completion (responseObject, nil);
     }
                                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR checking account ====\n%@",error.userInfo);
         completion(nil, error);
     }];
}

- (void)getUserMemesWithCompletion:(resultCompletion)completion
{
    [[MPNetworkManager sharedManager] POST:kGetUserMemesEndpoint
                                parameters:nil
                                  progress:nil
                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         completion (responseObject, nil);
     }
                                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"\n============== ERROR getting user memes ====\n%@",error.userInfo);
         completion(nil, error);
     }];
}

@end
