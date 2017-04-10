//
//  MPNetworkManager.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/10/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPNetworkManager.h"

#define BASE_URL @"https://makeameme.org"

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
            AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//            AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];

            [responseSerializer setRemovesKeysWithNullValues:YES];
            responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
            
            self.responseSerializer = responseSerializer;
            
        }
        return self;
    }
@end
