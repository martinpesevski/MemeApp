//
//  MPMemeMakerViewController.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 3/22/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPMemeMakerViewController.h"
#import "Masonry.h"
#import "Constants.h"

#define kMemeImageHeightWidth 300

@interface MPMemeMakerViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImage *memeImage;
@property (nonatomic, strong) UIImageView *memeImageView;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UITextField *topTextField;
@property (nonatomic, strong) UITextField *bottomTextField;

@end

@implementation MPMemeMakerViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.memeImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setConstraints];
}

- (void)setupViews
{
    self.title = @"Enter top and bottom text";
    
    self.memeImageView = [[UIImageView alloc] initWithImage:self.memeImage];
    self.memeImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.memeImageView.clipsToBounds = YES;
    self.memeImageView.layer.borderWidth = 1;
    self.memeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.text = @"TOP TEXT";
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.numberOfLines = 0;
    self.topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.topLabel.adjustsFontSizeToFitWidth = YES;
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.text = @"BOTTOM TEXT";
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bottomLabel.adjustsFontSizeToFitWidth = YES;
    
    self.topTextField = [[UITextField alloc] init];
    self.topTextField.delegate = self;
    self.topTextField.backgroundColor = [UIColor whiteColor];
    self.topTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.topTextField.placeholder = @"Enter top text here";

    self.bottomTextField = [[UITextField alloc] init];
    self.bottomTextField.delegate = self;
    self.bottomTextField.backgroundColor = [UIColor whiteColor];
    self.bottomTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.bottomTextField.placeholder = @"Enter bottom text here";

    [self.view addSubview:self.memeImageView];
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.bottomLabel];
    [self.view addSubview:self.topTextField];
    [self.view addSubview:self.bottomTextField];
}

- (void)setConstraints
{
    [self.memeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kLeftRightPadding);
        make.width.height.equalTo(@(kMemeImageHeightWidth));
        make.centerX.equalTo(self.view);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.memeImageView).offset(kLeftRightPadding);
        make.right.equalTo(self.memeImageView).offset(-kLeftRightPadding);
        make.top.equalTo(self.memeImageView).offset(kLeftRightPadding);
        make.height.lessThanOrEqualTo(@(kMemeImageHeightWidth/2 - 20));
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.memeImageView).offset(kLeftRightPadding);
        make.right.equalTo(self.memeImageView).offset(-kLeftRightPadding);
        make.bottom.equalTo(self.memeImageView).offset(-kLeftRightPadding);
        make.height.lessThanOrEqualTo(@(kMemeImageHeightWidth/2 - 20));
    }];
    [self.topTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kLeftRightPadding);
        make.right.equalTo(self.view).offset(-kLeftRightPadding);
        make.top.equalTo(self.memeImageView.mas_bottom).offset(kLeftRightPadding);
        make.height.equalTo(@(kMemeTextfieldHeight));
    }];
    [self.bottomTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kLeftRightPadding);
        make.right.equalTo(self.view).offset(-kLeftRightPadding);
        make.top.equalTo(self.topTextField.mas_bottom).offset(kLeftRightPadding);
        make.height.equalTo(@(kMemeTextfieldHeight));
    }];
}

#pragma mark - textfield methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:self.topTextField]) {
        self.topLabel.text = [newString uppercaseString];
    } else {
        self.bottomLabel.text = [newString uppercaseString];
    }
    return YES;
}

@end
