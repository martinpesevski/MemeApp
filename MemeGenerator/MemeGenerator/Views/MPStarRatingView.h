//
//  MPStarRatingView.h
//  AllHotels
//
//  Created by Martin Peshevski on 3/4/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPStarRatingView : UIView

- (void)setupWithNumberOfStars:(int)numberOfStars;
- (void)setStarColor:(UIColor *)starColor;

@end
