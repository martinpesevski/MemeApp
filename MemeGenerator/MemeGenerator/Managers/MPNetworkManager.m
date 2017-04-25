//
//  MPNetworkManager.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/10/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPNetworkManager.h"
#import "NetworkConstants.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import "MPAuthenticationManager.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation MPNetworkManager

+ (MPNetworkManager *)sharedManager
    {
        static MPNetworkManager *sharedMyManager = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedMyManager = [[MPNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        });
        return sharedMyManager;
    }

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        
        self.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
        [self.requestSerializer setValue:@"C3EE7018F61B2CD40F2" forHTTPHeaderField:@"X-Mam-Secret"];
        
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        [responseSerializer setRemovesKeysWithNullValues:YES];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
        
        self.responseSerializer = responseSerializer;
        
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                     progress:(void (^)(NSProgress * _Nonnull))downloadProgress
                      success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                      failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    void (^authFailBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)task.response;
        if([httpResponse statusCode] == 401){
            NSLog(@"401 auth error!");
        }else{
            NSLog(@"no auth error");
            failure(task, error);
        }
    };
    
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kTokenIdentifier];
    
    if (credential) {
        [[MPNetworkManager sharedManager].requestSerializer setValue:credential.accessToken forHTTPHeaderField:@"X-Mam-Authtoken"];
    }
    
    NSURLSessionDataTask *task = [super GET:URLString parameters:parameters progress:downloadProgress success:success failure:authFailBlock];
    
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure
{
    void (^authFailBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)task.response;
        if([httpResponse statusCode] == 401){
            NSLog(@"401 auth error!");
        }else{
            NSLog(@"no auth error");
            failure(task, error);
        }
    };
    
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:kTokenIdentifier];
    
    if (credential) {
        [[MPNetworkManager sharedManager].requestSerializer setValue:credential.accessToken forHTTPHeaderField:@"X-Mam-Authtoken"];
    }
    
    
    NSURLSessionDataTask *task = [super POST:URLString parameters:parameters progress:uploadProgress success:success failure:authFailBlock];
    
    return task;
}


@end
