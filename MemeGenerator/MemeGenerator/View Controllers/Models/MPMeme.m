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
        self.stockMemeID = dict[@"id"];
        self.imageUrlString = [NSString stringWithFormat:@"https://makeameme.org/media/templates/%@", dict[@"image"]];
        self.imageThumbnailString = [NSString stringWithFormat:@"https://makeameme.org/media/templates/80/%@", dict[@"image"]];
        self.createdImageUrlString = [NSString stringWithFormat:@"https://media.makeameme.org/created/%@", dict[@"image"]];
        self.createdImageSmallThumbnailString = [NSString stringWithFormat:@"https://media.makeameme.org/created/80/%@", dict[@"image"]];
        self.createdImageMediumThumbnailString = [NSString stringWithFormat:@"https://media.makeameme.org/created/120/%@", dict[@"image"]];
        self.createdImageLargeThumbnailString = [NSString stringWithFormat:@"https://media.makeameme.org/created/250/%@", dict[@"image"]];
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

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.stockMemeID = [aDecoder decodeObjectForKey:@"stockMemeID"];
        self.imageUrlString = [aDecoder decodeObjectForKey:@"imageUrlString"];
        self.imageThumbnailString = [aDecoder decodeObjectForKey:@"imageThumbnailString"];
        self.createdImageUrlString = [aDecoder decodeObjectForKey:@"createdImageUrlString"];
        self.createdImageSmallThumbnailString = [aDecoder decodeObjectForKey:@"createdImageSmallThumbnailString"];
        self.createdImageMediumThumbnailString = [aDecoder decodeObjectForKey:@"createdImageMediumThumbnailString"];
        self.createdImageLargeThumbnailString = [aDecoder decodeObjectForKey:@"createdImageLargeThumbnailString"];
        self.privacy = (MPMemePrivacy)[aDecoder decodeIntegerForKey:@"privacy"];
        self.topText = [aDecoder decodeObjectForKey:@"topText"];
        self.bottomText = [aDecoder decodeObjectForKey:@"bottomText"];
        self.localImageID = [aDecoder decodeObjectForKey:@"localImageID"];
        self.memeID = [aDecoder decodeObjectForKey:@"memeID"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.stockMemeID forKey:@"stockMemeID"];
    [aCoder encodeObject:self.imageUrlString forKey:@"imageUrlString"];
    [aCoder encodeObject:self.imageThumbnailString forKey:@"imageThumbnailString"];
    [aCoder encodeObject:self.createdImageUrlString forKey:@"createdImageUrlString"];
    [aCoder encodeObject:self.createdImageSmallThumbnailString forKey:@"createdImageSmallThumbnailString"];
    [aCoder encodeObject:self.createdImageMediumThumbnailString forKey:@"createdImageMediumThumbnailString"];
    [aCoder encodeObject:self.createdImageLargeThumbnailString forKey:@"createdImageLargeThumbnailString"];
    [aCoder encodeInteger:self.privacy forKey:@"privacy"];
    [aCoder encodeObject:self.topText forKey:@"topText"];
    [aCoder encodeObject:self.bottomText forKey:@"bottomText"];
    [aCoder encodeObject:self.localImageID forKey:@"localImageID"];
    [aCoder encodeObject:self.memeID forKey:@"memeID"];
}

@end
