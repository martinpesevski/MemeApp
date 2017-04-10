//
//  MPMeme.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/28/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMeme : NSObject

@property (nonatomic, strong) NSString *imageUrlString;
@property (nonatomic, strong) NSString *imageThumbnailString;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *memeID;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name;

@end
