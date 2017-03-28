//
//  MPMeme.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/28/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMeme.h"

@implementation MPMeme

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.image = image;
        self.name = name;
    }
    return self;
}

@end
