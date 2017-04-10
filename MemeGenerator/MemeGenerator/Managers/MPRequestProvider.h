//
//  MPRequestProvider.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/10/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^resultCompletion)(id result, NSError *error);

@interface MPRequestProvider : NSObject

+ (MPRequestProvider *)sharedInstance;
- (void)getMemesWithCompletion:(resultCompletion)completion;

@end
