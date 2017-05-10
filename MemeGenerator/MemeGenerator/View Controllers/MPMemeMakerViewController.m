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
#import "AppDelegate.h"
#import "Strings.h"
#import "MPDatabaseManager.h"

#define kMemeImageHeightWidth 300

typedef void (^customBlock)();

typedef enum MPTextLocation {
    MPTextLocationTop,
    MPTextLocationBottom
} MPTextLocation;

@interface MPMemeMakerViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) MPMeme *createdMeme;
@property (nonatomic, strong) MPMeme *meme;

@property (nonatomic, strong) UIImage *memeImage;
@property (nonatomic, strong) UIImage *modifiedImage;

@property (nonatomic, strong) UIImageView *memeImageView;
@property (nonatomic, strong) UIButton *selectFontButton;
@property (nonatomic, strong) UISwitch *outlineSwitch;
@property (nonatomic, strong) UISwitch *shadowSwitch;
@property (nonatomic, strong) UISwitch *allCapsSwitch;
@property (nonatomic, strong) UILabel *textOutlineLabel;
@property (nonatomic, strong) UILabel *textShadowLabel;
@property (nonatomic, strong) UILabel *allCapsLabel;
@property (nonatomic, strong) UILabel *fontSizeLabel;

@property (nonatomic, strong) UIView *outlineShadowContainer;
@property (nonatomic, strong) UIView *fontSizeContainer;
@property (nonatomic, strong) UIView *capitalizeLettersContainer;

@property (nonatomic, strong) UISlider *fontSizeSlider;

@property (nonatomic) int preferredFontSize;
@property (nonatomic) int fontSize;

@property (nonatomic, strong) NSString *selectedFontName;

@property (nonatomic, strong) UITextField *topTextField;
@property (nonatomic, strong) UITextField *bottomTextField;

@property (nonatomic, strong) UIButton *createButton;

@property (nonatomic, strong) NSArray *fontNamesArray;

@end

@implementation MPMemeMakerViewController

- (instancetype)initWithMeme:(MPMeme *)meme
{
    self = [super init];
    if (self) {
        self.memeImage = meme.image;
        self.meme = meme;
        self.preferredFontSize = [self getFontSizeForImageSize:meme.image.size];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setConstraints];
    [self tabbarSetup];
}

- (void)setupViews
{
    self.title = kMemeMakerTitleString;
    
    self.fontNamesArray = @[@"impact", @"Arial-BoldMT", @"cambria-bold"];
    self.selectedFontName = self.fontNamesArray[0];
    
    self.mainScrollView = [[UIScrollView alloc] init];
    
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
    self.topTextField.placeholder = kTopTitlePlaceholderString;
    self.topTextField.returnKeyType = UIReturnKeyNext;

    self.bottomTextField = [[UITextField alloc] init];
    self.bottomTextField.delegate = self;
    self.bottomTextField.backgroundColor = [UIColor whiteColor];
    self.bottomTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.bottomTextField.placeholder = kBottomTitlePlaceholderString;
    self.bottomTextField.returnKeyType = UIReturnKeyDone;
    
    self.selectFontButton = [[UIButton alloc] init];
    [self.selectFontButton setTitle:kChangeFontString forState:UIControlStateNormal];
    [self.selectFontButton addTarget:self action:@selector(onChangeFont) forControlEvents:UIControlEventTouchUpInside];
    [self.selectFontButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    self.selectFontButton.backgroundColor = [MPColorManager getNavigationBarColor];
    
    self.textOutlineLabel = [[UILabel alloc] init];
    self.textOutlineLabel.text = kTextOutlineString;
    self.textOutlineLabel.textColor = [MPColorManager getLabelColorBlack];
    
    self.outlineSwitch = [[UISwitch alloc] init];
    [self.outlineSwitch addTarget:self action:@selector(onSwitch) forControlEvents:UIControlEventValueChanged];
    self.outlineSwitch.tintColor = [MPColorManager getNavigationBarColor];
    self.outlineSwitch.onTintColor = [MPColorManager getNavigationBarColor];
    [self.outlineSwitch setOn:YES];
    
    self.textShadowLabel = [[UILabel alloc] init];
    self.textShadowLabel.text = kTextShadowString;
    self.textShadowLabel.textColor = [MPColorManager getLabelColorBlack];
    
    self.outlineShadowContainer = [[UIView alloc] init];
    
    self.allCapsSwitch = [[UISwitch alloc] init];
    [self.allCapsSwitch setOn:YES];
    [self.allCapsSwitch addTarget:self action:@selector(onSwitch) forControlEvents:UIControlEventValueChanged];
    self.allCapsSwitch.tintColor = [MPColorManager getNavigationBarColor];
    self.allCapsSwitch.onTintColor = [MPColorManager getNavigationBarColor];
    
    self.allCapsLabel = [[UILabel alloc] init];
    self.allCapsLabel.text = kCapitalizeLettersString;
    self.allCapsLabel.textColor = [MPColorManager getLabelColorBlack];
    
    self.capitalizeLettersContainer = [[UIView alloc] init];
    
    self.shadowSwitch = [[UISwitch alloc] init];
    [self.shadowSwitch addTarget:self action:@selector(onSwitch) forControlEvents:UIControlEventValueChanged];
    self.shadowSwitch.tintColor = [MPColorManager getNavigationBarColor];
    self.shadowSwitch.onTintColor = [MPColorManager getNavigationBarColor];
    
    self.fontSizeLabel = [[UILabel alloc] init];
    self.fontSizeLabel.text = kFontSizeString;
    self.fontSizeLabel.textColor = [MPColorManager getLabelColorBlack];
    
    self.fontSizeSlider = [[UISlider alloc] init];
    self.fontSizeSlider.minimumValue = 10;
    self.fontSizeSlider.maximumValue = 50;
    self.fontSizeSlider.value = 30;
    self.fontSizeSlider.tintColor = [MPColorManager getNavigationBarColor];
    [self.fontSizeSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.fontSize = self.preferredFontSize * (self.fontSizeSlider.value/20);
    
    self.fontSizeContainer = [[UIView alloc] init];
    
    self.createButton = [[UIButton alloc] init];
    [self.createButton setTitle:kCreateString forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(onCreate) forControlEvents:UIControlEventTouchUpInside];
    [self.createButton setTitleColor:[MPColorManager getLabelColorWhite] forState:UIControlStateNormal];
    self.createButton.backgroundColor = [MPColorManager getNavigationBarColor];

    [self.mainScrollView addSubview:self.memeImageView];
    [self.mainScrollView addSubview:self.topTextField];
    [self.mainScrollView addSubview:self.bottomTextField];
    [self.mainScrollView addSubview:self.selectFontButton];
    [self.outlineShadowContainer addSubview:self.textOutlineLabel];
    [self.outlineShadowContainer addSubview:self.outlineSwitch];
    [self.outlineShadowContainer addSubview:self.textShadowLabel];
    [self.outlineShadowContainer addSubview:self.shadowSwitch];
    [self.mainScrollView addSubview:self.outlineShadowContainer];
    [self.capitalizeLettersContainer addSubview:self.allCapsLabel];
    [self.capitalizeLettersContainer addSubview:self.allCapsSwitch];
    [self.mainScrollView addSubview:self.capitalizeLettersContainer];
    [self.fontSizeContainer addSubview:self.fontSizeLabel];
    [self.fontSizeContainer addSubview:self.fontSizeSlider];
    [self.mainScrollView addSubview: self.fontSizeContainer];
    [self.view addSubview:self.mainScrollView];
    [self.view addSubview:self.createButton];
}

- (void)setConstraints
{
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.createButton.mas_top).offset(-20);
    }];
    [self.memeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainScrollView).offset(kLeftRightPadding);
        make.width.height.equalTo(@(kMemeImageHeightWidth));
        make.centerX.equalTo(self.view);
    }];
    [self.topTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kLeftRightPadding);
        make.right.equalTo(self.view).offset(-kLeftRightPadding);
        make.left.equalTo(self.mainScrollView).offset(kLeftRightPadding);
        make.right.equalTo(self.mainScrollView).offset(-kLeftRightPadding);
        make.top.equalTo(self.memeImageView.mas_bottom).offset(kLeftRightPadding);
        make.height.equalTo(@(kMemeTextfieldHeight));
    }];
    [self.bottomTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kLeftRightPadding);
        make.right.equalTo(self.view).offset(-kLeftRightPadding);
        make.top.equalTo(self.topTextField.mas_bottom).offset(kLeftRightPadding);
        make.height.equalTo(@(kMemeTextfieldHeight));
    }];
    [self.fontSizeContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    [self.fontSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fontSizeContainer);
        make.centerY.equalTo(self.fontSizeSlider);
    }];
    [self.fontSizeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fontSizeLabel.mas_right).offset(10);
        make.width.equalTo(@100);
        make.right.top.bottom.equalTo(self.fontSizeContainer);
    }];
    [self.outlineShadowContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.fontSizeContainer.mas_bottom).offset(20);
    }];
    [self.textOutlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.outlineShadowContainer);
        make.centerY.equalTo(self.outlineSwitch);
    }];
    [self.outlineSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.outlineShadowContainer);
        make.left.equalTo(self.textOutlineLabel.mas_right).offset(10);
    }];
    [self.textShadowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.outlineSwitch.mas_right).offset(20);
        make.centerY.equalTo(self.shadowSwitch);
    }];
    [self.shadowSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.outlineSwitch);
        make.left.equalTo(self.textShadowLabel.mas_right).offset(10);
        make.right.equalTo(self.outlineShadowContainer);
        make.bottom.equalTo(self.outlineShadowContainer);
    }];
    [self.selectFontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.outlineShadowContainer.mas_bottom).offset(20);
        make.height.equalTo(@(kLoginButtonHeight));
        make.width.equalTo(@(kScreenWidth / 3));
        make.centerX.equalTo(self.view);
    }];
    [self.capitalizeLettersContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.selectFontButton.mas_bottom).offset(20);
        make.bottom.equalTo(self.mainScrollView);
    }];
    [self.allCapsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.capitalizeLettersContainer);
        make.centerY.equalTo(self.allCapsSwitch);
    }];
    [self.allCapsSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.capitalizeLettersContainer);
        make.left.equalTo(self.allCapsLabel.mas_right).offset(10);
    }];
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.equalTo(@(kLoginButtonHeight));
        make.width.equalTo(@(kScreenWidth /3));
        make.bottom.equalTo(self.tabBar.mas_top).offset(-kLeftRightPadding);
    }];
}

- (void)tabbarSetup
{
    BOOL isLoggedIn = [[MPAuthenticationManager sharedManager] isLoggedIn];
    NSArray *names = @[kBackString, isLoggedIn?kLogoutString:kLoginRegisterString];
    NSArray *images = @[[UIImage imageNamed:@"ic_left_white"],[UIImage new]];
    
    simpleBlock backBlock = ^{
        [self onBack];
    };
    
    simpleBlock loginBlock = ^{
        if (isLoggedIn) {
            [MPAlertManager showAlertMessage:kLogoutConfirmString withOKblock:^{
                [[MPAuthenticationManager sharedManager] signOut];
            }];
        } else {
            [self showLogin];
        }
    };
    
    NSArray *actionsArray = @[backBlock, loginBlock];
    
    [self setupTabbarWithNames:names images:images actions:actionsArray];
}

- (BOOL)validation
{
    if (self.topTextField.text.length == 0 && self.bottomTextField.text.length == 0) {
        [MPAlertManager showAlertMessage:@"Please enter top or bottom text" withOKblock:nil hasCancelButton:NO];
        return NO;
    }
    
    return YES;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.topTextField) {
        [self.topTextField resignFirstResponder];
        [self.bottomTextField becomeFirstResponder];
    } else {
        [self.bottomTextField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - button actions

- (void)onCreate
{
    if (![self validation]) {
        return;
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self saveImageWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MPShareMemeViewController *shareMemeController = [[MPShareMemeViewController alloc] initWithMeme:self.createdMeme];
            [self.navigationController pushViewController:shareMemeController animated:YES];
        });
    }];
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
    
    [MPAlertManager showActionSheetWithTitles:self.fontNamesArray blocks:blocksArray sourceView:self.view title:kSelectAFontString];
}

#pragma mark - switch methods

- (void)onSwitch
{
    [self updateImageWithTopText:self.topTextField.text bottomText:self.bottomTextField.text];
}

#pragma mark - slider methods

- (void)onSliderValueChanged:(UISlider *)slider
{
    [slider setValue:(int)slider.value animated:NO];
    
    self.fontSize = self.preferredFontSize * (slider.value/20);
    [self updateImageWithTopText:self.topTextField.text bottomText:self.bottomTextField.text];
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

    NSString *topTextWithCapitalization = self.allCapsSwitch.isOn?[topText uppercaseString]:topText;
    NSString *bottomTextWithCapitalization = self.allCapsSwitch.isOn?[bottomText uppercaseString]:bottomText;

    [self drawText:topTextWithCapitalization location:MPTextLocationTop withFont:font];
    [self drawText:bottomTextWithCapitalization location:MPTextLocationBottom withFont:font];
    
    self.modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    self.memeImageView.image = self.modifiedImage;
    UIGraphicsEndImageContext();
}

- (void)drawText:(NSString *)text location:(MPTextLocation)location withFont:(UIFont *)font
{
    UIFont *modifiedFont = font;
    if (self.outlineSwitch.isOn) {
        modifiedFont = [UIFont fontWithName:font.fontName size:font.pointSize +3];
    }
    NSDictionary *attributes = @{NSFontAttributeName: modifiedFont};
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
    
    NSMutableDictionary *textAttributes = [[NSMutableDictionary alloc] init];
    [textAttributes setObject:font forKey:NSFontAttributeName];
    [textAttributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [textAttributes setObject:[MPColorManager getLabelColorWhite] forKey:NSForegroundColorAttributeName];
    
    if (self.outlineSwitch.isOn) {
        [textAttributes setObject:[UIColor blackColor] forKey:NSStrokeColorAttributeName];
        [textAttributes setObject:@-3.0f forKey:NSStrokeWidthAttributeName];
        [textAttributes setObject:modifiedFont forKey:NSFontAttributeName];
    }
    if (self.shadowSwitch.isOn) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetShadow(context, CGSizeMake(10.0f, 10.0f), 10.0f);
    }
    
    [text drawInRect:CGRectIntegral(rect)
                    withAttributes:textAttributes];
}

- (void)saveImageWithCompletion:(MPSimpleBlock)completion
{
    [[MPDatabaseManager sharedInstance] saveImage:self.modifiedImage completion:^(NSString *imageID) {
        NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        NSString *imageName = [NSString stringWithFormat:@"meme%@", timestamp];
        
        self.createdMeme = self.meme;
        self.createdMeme.image = self.modifiedImage;
        self.createdMeme.name = imageName;
        self.createdMeme.topText = self.topTextField.text;
        self.createdMeme.bottomText = self.bottomTextField.text;
        self.createdMeme.localImageID = imageID;
        
        [[MPDatabaseManager sharedInstance] saveMeme:self.createdMeme];
        
        completion();
    }];
}

@end
