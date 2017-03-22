//
//  MPTextField.m
//  Betting
//
//  Created by Martin Peshevski on 5/18/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPTextField.h"
#import "Masonry.h"

@interface MPTextField ()

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIColor *color;

@end

@implementation MPTextField

- (instancetype)initWithColor:(UIColor *)color;
{
    self = [super init];
    if (self) {
        self.color = color;
        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.floatingLabelActiveTextColor = color;
        self.floatingLabelTextColor = color;
        self.tintColor = color;
//        self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:kEmailString attributes:@{NSForegroundColorAttributeName: [MPColorManager getLabelColorWhite]}];
        
        [self setupBottomLine];
    }
    return self;
}

- (void)setupBottomLine
{
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = self.color;
    
    [self addSubview:self.bottomLine];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@2);
    }];
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 4);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 4);
}

@end
