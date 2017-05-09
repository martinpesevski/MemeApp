//
//  MPRequestProvider.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 4/10/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMeme.h"
#import "Constants.h"

@interface MPRequestProvider : NSObject

+ (MPRequestProvider *)sharedInstance;
- (void)registerWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password completion:(resultCompletion)completion;
- (void)getMemesWithCompletion:(resultCompletion)completion;
- (void)checkAccountWithCompletion:(resultCompletion)completion;
- (void)getUserMemesWithCompletion:(resultCompletion)completion;
- (void)postMeme:(MPMeme *)meme completion:(resultCompletion)completion;
- (void)updatePrivacyForMeme:(MPMeme *)meme completion:(resultCompletion)completion;

@end
