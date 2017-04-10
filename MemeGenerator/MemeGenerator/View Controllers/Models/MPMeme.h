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

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
