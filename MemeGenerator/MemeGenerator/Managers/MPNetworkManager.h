//
//  MPNetworkManager.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/10/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface MPNetworkManager : AFHTTPSessionManager

+ (MPNetworkManager *)sharedManager;

@end
