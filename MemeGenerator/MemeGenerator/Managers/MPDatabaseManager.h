//
//  MPDatabaseManager.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 5/9/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MPMeme.h"

@interface MPDatabaseManager : NSObject

+ (MPDatabaseManager *)sharedInstance;

- (void)saveImage:(UIImage *)image completion:(stringCompletion)completion;
- (void)loadImageFromImageID:(NSString *)imageID completion:(imageCompletion)completion;
- (void)saveMeme:(MPMeme *)meme;

@end
