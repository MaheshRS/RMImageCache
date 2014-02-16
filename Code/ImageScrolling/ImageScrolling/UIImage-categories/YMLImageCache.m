
//
//  YMLImageCache.m
//  wakeupnow
//
//  Created by Vivek Rajanna on 24/12/11.
//  Copyright (c) 2011 YMedia Labs. All rights reserved.
//
#import "YMLImageCache.h"
#import <CommonCrypto/CommonDigest.h>

static NSInteger cacheMaxCacheAge = 60*60*24*7; // 1 week

static YMLImageCache *instance;

@implementation YMLImageCache

#pragma mark YMLImageCache (notification handlers)

- (void)didReceiveMemoryWarning:(void *)object
{
    [self clearMemory];
}

- (void)willTerminate
{
    [self cleanDisk];
}

#pragma mark NSObject

- (id)init
{
    if ((self = [super init]))
    {
        // Init the memory cache
        imageCache = [[NSCache alloc]init];

        // Init the disk cache
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        diskCachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"];
        		
        if (![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath])
        {
          //  [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath attributes:nil];
            
            [[NSFileManager defaultManager]createDirectoryAtPath:diskCachePath withIntermediateDirectories:NO attributes:nil error:nil];
        }

        // Init the operation queue
        cacheInQueue = [[NSOperationQueue alloc] init];
        cacheInQueue.maxConcurrentOperationCount = 2;

        // Subscribe to app events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveMemoryWarning:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification  
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willTerminate)
                                                     name:UIApplicationWillTerminateNotification  
                                                   object:nil];        
    }

    return self;
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification  
                                                  object:nil];  

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillTerminateNotification  
                                                  object:nil];  
    
}

#pragma mark YMlImageCache (class methods)

+ (YMLImageCache *)sharedImageCache
{
    if (instance == nil)
    {
        instance = [[YMLImageCache alloc] init];
    }
    
    return instance;
}

#pragma mark SDImageCache (private)

- (NSString *)cachePathForKey:(NSString *)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];

    return [diskCachePath stringByAppendingPathComponent:filename];
}

- (void)storeKeyToDisk:(NSString *)key
{
    UIImage *image = [self imageFromKey:key fromDisk:YES]; // be thread safe with no lock

    if (image != nil)
    {
        [[NSFileManager defaultManager] createFileAtPath:[self cachePathForKey:key] contents:UIImageJPEGRepresentation(image, (CGFloat)1.0) attributes:nil];
    }
}

#pragma mark ImageCache

- (void)storeImage:(UIImage *)image forKey:(NSString *)key
{
    [self storeImage:image forKey:key toDisk:YES];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (image == nil || key == nil)
    {
        return;
    }

    [imageCache setObject:image forKey:key];

    if (toDisk)
    {        
        [cacheInQueue addOperation:[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(storeKeyToDisk:) object:key]];
    }
}

- (UIImage *)imageFromKey:(NSString *)key
{
    return [self imageFromKey:key fromDisk:YES];
}

- (UIImage *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk
{
    if (key == nil)
    {
        return nil;
    }

    UIImage *image = [imageCache objectForKey:key];
    if (!image && fromDisk)
    {
        image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[self cachePathForKey:key]]];
        if (image != nil)
        {
            [imageCache setObject:image forKey:key];
        }
    }

    return image;
}

- (void)removeImageForKey:(NSString *)key
{
    if (key == nil)
    {
        return;
    }

    [imageCache removeAllObjects];
    [[NSFileManager defaultManager] removeItemAtPath:[self cachePathForKey:key] error:nil];
}

- (void)clearMemory
{
    [cacheInQueue cancelAllOperations]; // won't be able to complete
    [imageCache removeAllObjects];
}

- (void)clearDisk
{
    [cacheInQueue cancelAllOperations];
    [[NSFileManager defaultManager] removeItemAtPath:diskCachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath withIntermediateDirectories:NO attributes:nil error:nil];
//    [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath attributes:nil];    
}

- (void)cleanDisk
{
    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-cacheMaxCacheAge];
    NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:diskCachePath];
    for (NSString *fileName in fileEnumerator)
    {
        NSString *filePath = [diskCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        if ([[[attrs fileModificationDate] laterDate:expirationDate] isEqualToDate:expirationDate])
        {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
}

@end
