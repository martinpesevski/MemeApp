//
//  MPShareMemeViewController.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/28/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"
#import "MPMeme.h"

@interface MPShareMemeViewController : MPBaseViewController

- (instancetype)initWithMeme:(MPMeme *)meme;

@end
