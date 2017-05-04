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
        self.privacy = [self privacyFromString:dict[@"visibility"]];
        self.topText = dict[@"topText"];
        self.bottomText = dict[@"bottomText"];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
        self.image = image;
        self.privacy = MPMemePrivacyPrivate;
    }
    return self;
}

- (MPMemePrivacy)privacyFromString:(NSString *)privacyString
{
    if ([privacyString isEqualToString:@"private"]) {
        return MPMemePrivacyPrivate;
    }
    
    return MPMemePrivacyPublic;
}

- (NSString *)stringFromMemePrivacy:(MPMemePrivacy)privacyType
{
    switch (privacyType) {
        case MPMemePrivacyPrivate:
            return @"private";
            break;
            
        default:
            return @"public";
            break;
    }
}


@end
