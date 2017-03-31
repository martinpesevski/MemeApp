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

typedef void (^customBlock)();

typedef enum MPTextLocation {
    MPTextLocationTop,
    MPTextLocationBottom
} MPTextLocation;

@interface MPMemeMakerViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImage *memeImage;
@property (nonatomic, strong) UIImage *modifiedImage;

@property (nonatomic, strong) UIImageView *memeImageView;
@property (nonatomic, strong) UIButton *selectFontButton;

@property (nonatomic) int fontSize;

@property (nonatomic, strong) NSString *selectedFontName;

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
        self.fontSize = [self getFontSizeForImageSize:image.size];
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
    self.memeImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.memeImageView.clipsToBounds = YES;
    self.memeImageView.layer.borderWidth = 1;
    self.memeImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.memeImageView.backgroundColor = [UIColor blackColor];
    
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
        [self updateImageWithTopText:newString bottomText:self.bottomTextField.text];
    } else {
        [self updateImageWithTopText:self.topTextField.text bottomText:newString];
    }
    return YES;
}

#pragma mark - button actions

- (void)onCreate
{
    UIImageWriteToSavedPhotosAlbum(self.modifiedImage, nil, nil, nil);
    
    MPShareMemeViewController *shareMemeController = [[MPShareMemeViewController alloc] initWithImage:self.modifiedImage];
    [self.navigationController pushViewController:shareMemeController animated:YES];
}

- (void)onChangeFont
{
    NSMutableArray *blocksArray = [[NSMutableArray alloc] init];
    for (NSString *fontName in self.fontNamesArray) {
        __weak MPMemeMakerViewController *weakSelf = self;
        customBlock block = ^void() {
            weakSelf.selectedFontName = fontName;
            [weakSelf updateImageWithTopText:weakSelf.topTextField.text bottomText:weakSelf.bottomTextField.text];
        };
        [blocksArray addObject:block];
    }
    
    [MPAlertManager showActionSheetWithTitles:self.fontNamesArray blocks:blocksArray sourceView:self.view title:@"select a font"];
}

#pragma mark - helper methods

- (int)getFontSizeForImageSize:(CGSize)size
{
    return ((size.height * 2)/5)/5;
}

- (void)updateImageWithTopText:(NSString *)topText bottomText:(NSString *)bottomText
{
    UIFont *font = [UIFont fontWithName:self.selectedFontName size:self.fontSize];

    UIGraphicsBeginImageContext(self.memeImage.size);
    
    [self.memeImage drawInRect:CGRectMake(0,0,self.memeImage.size.width,self.memeImage.size.height)];

    [self drawText:topText location:MPTextLocationTop withFont:font outlined:NO];
    [self drawText:bottomText location:MPTextLocationBottom withFont:font outlined:NO];
    
    self.modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    self.memeImageView.image = self.modifiedImage;
    UIGraphicsEndImageContext();
}

- (void)drawText:(NSString *)text location:(MPTextLocation)location withFont:(UIFont *)font outlined:(BOOL)isOutlined
{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    float labelWidth = (self.memeImage.size.width - 2 * kLeftRightPadding);
    float labelHeight = (self.memeImage.size.height * 2)/5;
    CGRect labelRect = [text boundingRectWithSize:CGSizeMake(labelWidth, labelHeight)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    float pointx = self.memeImage.size.width/2 - labelRect.size.width/2;
    
    CGRect rect;
    if (location == MPTextLocationTop) {
        rect = CGRectMake(pointx, kLeftRightPadding, labelRect.size.width, labelRect.size.height);
    } else {
        rect = CGRectMake(pointx,
                          self.memeImage.size.height - (labelRect.size.height +kLeftRightPadding),
                          labelRect.size.width,
                          labelRect.size.height);
    }
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [text drawInRect:CGRectIntegral(rect)
                    withAttributes:@{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName: paragraphStyle,
                                     NSForegroundColorAttributeName: [MPColorManager getLabelColorWhite]}];
}


@end
