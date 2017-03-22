//
//  MPAlertManager.m
//  Betting
//
//  Created by Martin Peshevski on 5/13/16.
//  Copyright © 2016 Martin Peshevski. All rights reserved.
//

#import "MPAlertManager.h"
#import "AppDelegate.h"
#import "MPControllerManager.h"

@implementation MPAlertManager

+ (void)showAlertMessage:(NSString*)message
{
    [MPAlertManager showAlertMessage:message withOKblock:nil];
}

+ (void)showAlertMessage:(NSString*)message withOKblock:(MPSimpleBlock)callbackBlock
{
    [MPAlertManager showAlertMessage:message withOKblock:callbackBlock hasCancelButton:YES];
}

+ (void)showAlertMessage:(NSString *)message withOKblock:(MPSimpleBlock)callbackBlock hasCancelButton:(BOOL)hasCancelButton
{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    if (hasCancelButton) {
        UIAlertAction* cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                       handler:nil];
        [alert addAction:cancelAction];
    }

    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        if (callbackBlock) {
                                            callbackBlock();
                                        }
                                    }];
    
    [alert addAction:defaultAction];
    
    UIViewController *topController = [MPControllerManager getTopViewController];
    if ([topController isKindOfClass:[UIAlertController class]]) {
        //prevent from displaying multilple alerts at the same time
        return;
    }
    
    [topController presentViewController:alert animated:YES completion:nil];
}

+ (void)showActionSheetWithTitles:(NSArray *)titles
                           blocks:(NSArray *)blocks
                       sourceView:(UIView *)sourceView
                            title:(NSString *)title
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title
                                                                         message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    for (int i=0; i<titles.count; i++) {
        NSString *title = titles[i];
        MPSimpleBlock completionBlock = blocks[i];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            if (blocks.count>i) {
                completionBlock();
            }
        }]];
    }
    
    UIPopoverPresentationController *popPresenter = [actionSheet
                                                     popoverPresentationController];
    popPresenter.sourceView = sourceView;
    popPresenter.sourceRect = sourceView.bounds;
    
    // Present action sheet.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *topController = [MPControllerManager topViewControllerWithRootViewController:appDelegate.viewController];
    
    [topController presentViewController:actionSheet animated:YES completion:nil];
}

@end
