//
//  MPDatabaseManager.m
//  MemeGenerator
//
//  Created by Martin Peshevski on 5/9/17.
//  Copyright © 2017 Martin Peshevski. All rights reserved.
//

#import "MPDatabaseManager.h"
#import <Photos/Photos.h>

@implementation MPDatabaseManager

+ (MPDatabaseManager *)sharedInstance
{
    static MPDatabaseManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MPDatabaseManager alloc] init];
    });
    return sharedManager;
}

- (void)saveImage:(UIImage *)image completion:(stringCompletion)completion
{
    __block NSString *localImageId;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        localImageId = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            if (completion) {
                completion(nil);
            }
        } else{
            completion(localImageId);
        }
    }];
}

- (void)loadImageFromImageID:(NSString *)imageID completion:(imageCompletion)completion
{
    PHFetchResult* assetResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[imageID] options:nil];
    PHAsset *asset = [assetResult firstObject];
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        UIImage *newImage = [UIImage imageWithData:imageData];
        if (completion) {
            completion(newImage);
        }
    }];
}

- (void)saveMeme:(MPMeme *)meme
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"memes/%@", meme.name]];
    
    [NSKeyedArchiver archiveRootObject:meme toFile:filePath];
}

@end
