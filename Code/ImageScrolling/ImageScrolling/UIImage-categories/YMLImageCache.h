//
//  YMLImageCache.h
//  wakeupnow
//
//  Created by Vivek Rajanna on 24/12/11.
//  Copyright (c) 2011 YMedia Labs. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface YMLImageCache : NSObject
{
    NSCache *imageCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue;
}

+ (YMLImageCache *)sharedImageCache;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (UIImage *)imageFromKey:(NSString *)key;
- (UIImage *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (void)removeImageForKey:(NSString *)key;
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;

@end
