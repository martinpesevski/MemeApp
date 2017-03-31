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
#import "MPColorManager.h"
#import "MPShareMemeViewController.h"
#import "MPAlertManager.h"

#define kMemeImageHeightWidth 300
#define kFontSize 20

typedef void (^customBlock)();

@interface MPMemeMakerViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImage *memeImage;
@property (nonatomic, strong) UIImageView *memeImageView;
@property (nonatomic, strong) UIButton *selectFontButton;

@property (nonatomic, strong) NSString *selectedFontName;

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UITextField *topTextField;
@property (nonatomic, strong) UITextField *bottomTextField;

@property (nonatomic, strong) UIButton *createButton;

@property (nonatomic, strong) NSArray *fontNamesArray;

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
    
    self.fontNamesArray = @[@"impact", @"Arial-BoldMT", @"cambria-bold"];
    self.selectedFontName = self.fontNamesArray[0];
    
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
    self.topLabel.font = [UIFont fontWithName:@"impact" size:kFontSize];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.text = @"BOTTOM TEXT";
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bottomLabel.adjustsFontSizeToFitWidth = YES;
    self.bottomLabel.font = [UIFont fontWithName:@"impact" size:kFontSize];

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
    
    self.selectFontButton = [[UIButton alloc] init];
    [self.selectFontButton setTitle:@"Change font" forState:UIControlStateNormal];
    [self.selectFontButton addTarget:self action:@selector(onChangeFont) forControlEvents:UIControlEventTouchUpInside];
    [self.selectFontButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    self.selectFontButton.backgroundColor = [MPColorManager getNavigationBarColor];
    
    self.createButton = [[UIButton alloc] init];
    [self.createButton setTitle:@"Create" forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(onCreate) forControlEvents:UIControlEventTouchUpInside];
    [self.createButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    self.createButton.backgroundColor = [MPColorManager getNavigationBarColor];

    [self.view addSubview:self.memeImageView];
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.bottomLabel];
    [self.view addSubview:self.topTextField];
    [self.view addSubview:self.bottomTextField];
    [self.view addSubview:self.selectFontButton];
    [self.view addSubview:self.createButton];
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
    [self.selectFontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomTextField.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        make.width.equalTo(@(kScreenWidth / 3));
        make.centerX.equalTo(self.view);
    }];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(kLoginButtonHeight));
        make.width.equalTo(@(kScreenWidth /3));
        make.bottom.equalTo(self.view).offset(-kLeftRightPadding);
    }];
}

#pragma mark - textfield methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:self.topTextField]) {
        [self drawText:[newString uppercaseString] onLabel:self.topLabel withFontName:self.selectedFontName];
    } else {
        [self drawText:[newString uppercaseString] onLabel:self.bottomLabel withFontName:self.selectedFontName];
    }
    return YES;
}

- (void)drawText:(NSString *)text onLabel:(UILabel *)label withFontName:(NSString *)fontName
{
    label.text = text;
    label.font = [UIFont fontWithName:fontName size:kFontSize];
}

#pragma mark - button actions

- (void)onCreate
{
    UIFont *font = [UIFont fontWithName:self.selectedFontName size:20];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    float labelWidth = (self.memeImage.size.width - 2 * kLeftRightPadding);
    CGRect topLabelRect = [self.topLabel.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:attributes
                                                           context:nil];
    
    CGRect bottomLabelRect = [self.bottomLabel.text boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:attributes
                                                           context:nil];
    
    UIGraphicsBeginImageContext(self.memeImage.size);
    [self.memeImage drawInRect:CGRectMake(0,0,self.memeImage.size.width,self.memeImage.size.height)];
    float pointx = self.memeImage.size.width/2 - topLabelRect.size.width/2;
    CGRect rect = CGRectMake(pointx, kLeftRightPadding, topLabelRect.size.width, topLabelRect.size.height);
    [[UIColor whiteColor] set];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    [self.topLabel.text drawInRect:CGRectIntegral(rect)
                        withAttributes:@{NSFontAttributeName:font,
                                         NSParagraphStyleAttributeName: paragraphStyle,
                                         NSForegroundColorAttributeName: [MPColorManager getLabelColorWhite]}];

    pointx = self.memeImage.size.width/2 - bottomLabelRect.size.width/2;
    rect = CGRectMake(pointx,
                      self.memeImage.size.height - (bottomLabelRect.size.height +kLeftRightPadding),
                      bottomLabelRect.size.width,
                      bottomLabelRect.size.height);

    [self.bottomLabel.text drawInRect:CGRectIntegral(rect) withAttributes:@{NSFontAttributeName:font,
                                                                                NSParagraphStyleAttributeName: paragraphStyle,
                                                                                NSForegroundColorAttributeName: [MPColorManager getLabelColorWhite]}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    
    MPShareMemeViewController *shareMemeController = [[MPShareMemeViewController alloc] initWithImage:newImage];
    [self.navigationController pushViewController:shareMemeController animated:YES];
}

- (void)onChangeFont
{
    NSMutableArray *blocksArray = [[NSMutableArray alloc] init];
    for (NSString *fontName in self.fontNamesArray) {
        __weak MPMemeMakerViewController *weakSelf = self;
        customBlock block = ^void() {
            weakSelf.selectedFontName = fontName;
            [self drawText:self.topTextField.text onLabel:self.topLabel withFontName:fontName];
            [self drawText:self.bottomTextField.text onLabel:self.bottomLabel withFontName:fontName];
        };
        [blocksArray addObject:block];
    }
    
    [MPAlertManager showActionSheetWithTitles:self.fontNamesArray blocks:blocksArray sourceView:self.view title:@"select a font"];
}

@end
