//
//  MPMemeMakerViewController.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"
#import "MPMeme.h"

@interface MPMemeMakerViewController : MPBaseViewController

- (instancetype)initWithMeme:(MPMeme *)meme;


@end
