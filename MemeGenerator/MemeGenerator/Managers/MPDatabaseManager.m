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
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"memes"];

    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:filePath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
    NSString *memeFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.meme", meme.name]];

    [NSKeyedArchiver archiveRootObject:meme toFile:memeFilePath];
}

- (void)loadLocalMemesWithCompletion:(arrayCompletion)completion
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent: @"memes"];
    
    int count;
    NSMutableArray *memesMutable = [[NSMutableArray alloc] init];
    NSError *error;
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSString *memeName = [directoryContent objectAtIndex:count];
        NSString *memePath = [filePath stringByAppendingPathComponent:memeName];
        MPMeme *meme = [NSKeyedUnarchiver unarchiveObjectWithFile:memePath];
        [memesMutable addObject:meme];
    }
    
    __block int counter = 0;
    for (MPMeme *meme in memesMutable) {
        [[MPDatabaseManager sharedInstance] loadImageFromImageID:meme.localImageID completion:^(UIImage *image) {
            counter ++;
            meme.image = image;
            
            if (counter == memesMutable.count) {
                completion(memesMutable);
            }
        }];
    }
    
}

@end
