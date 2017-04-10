//
//  MPMeme.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/28/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMeme.h"

@implementation MPMeme

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.memeID = dict[@"id"];
        self.imageUrlString = [NSString stringWithFormat:@"https://makeameme.org/media/templates/%@", dict[@"img"]];
        self.imageThumbnailString = [NSString stringWithFormat:@"https://makeameme.org/media/templates/80/%@", dict[@"img"]];
        self.name = dict[@"name"];
    }
    return self;
}

@end
