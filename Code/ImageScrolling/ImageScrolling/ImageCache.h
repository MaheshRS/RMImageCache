//
//  ImageCache.h
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kICmageFormatStyle32BitBGRA,
    kICImageFormatStyle32BitBGR,
    kICImageFormatStyle16BitBGR,
    kICImageFormatStyle8BitGrayscale,
}ICImageStyle;

typedef enum
{
    kICImageThumbnailSmall,
    kICImageThumbnailMedium,
    kICImageThumbnailLarge,
    kICImageNormal,
    kICImageMedium,
    kICImageLarge,
}ICImageType;

@interface ImageCache : NSObject

@property(nonatomic, assign, readonly)BOOL isConfiguring;

- (void)configureImageType:(ICImageType)imageType imageStyle:(ICImageStyle)style withSize:(CGSize)size;
- (NSString *)formatNameForStyle:(ICImageType)type;
- (void)finishConfiguringImageCache;

- (void)cacheImage:(NSString *)imageName imageURL:(NSURL *)image style:(ICImageType)type;
- (void)cacheImage:(NSString *)imageName image:(UIImage *)image imageURL:(NSURL *)imageURL style:(ICImageType)type;
@end
