//
//  MPMeme.h
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/28/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMeme : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *name;

- (instancetype)initWithImage:(UIImage *)image name:(NSString *)name;

@end
