//
//  MPRequestProvider.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/10/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMeme.h"

typedef void(^resultCompletion)(id result, NSError *error);
typedef void(^imageCompletion)(UIImage *image);

@interface MPRequestProvider : NSObject

+ (MPRequestProvider *)sharedInstance;
- (void)getMemesWithCompletion:(resultCompletion)completion;
- (void)checkAccountWithCompletion:(resultCompletion)completion;
- (void)getUserMemesWithCompletion:(resultCompletion)completion;
- (void)postMeme:(MPMeme *)meme completion:(resultCompletion)completion;

@end
