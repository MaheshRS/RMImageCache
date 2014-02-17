//
//  ImageCache.h
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionBlock)(UIImage *image, BOOL success);

typedef enum {
    kICmageFormatStyle32BitBGRA,
    kICImageFormatStyle32BitBGR,
    kICImageFormatStyle16BitBGR,
    kICImageFormatStyle8BitGrayscale,
}ICImageStyle;

typedef enum
{
    kICImageTypeThumbnailSmall,
    kICImageTypeThumbnailMedium,
    kICImageTypeThumbnailLarge,
    kICImageTypeNormal,
    kICImageTypeMedium,
    kICImageTypeLarge,
}ICImageType;

@interface ImageCache : NSObject

@property(nonatomic, assign, readonly)BOOL isConfiguring;

- (void)configureImageType:(ICImageType)imageType imageStyle:(ICImageStyle)style withSize:(CGSize)size;
- (NSString *)formatNameForStyle:(ICImageType)type;
- (void)finishConfiguringImageCache;

- (void)cacheImage:(NSString *)imageName imageURL:(NSURL *)image type:(ICImageType)type;
- (void)cacheImage:(NSString *)imageName
          imageURL:(NSURL *)imageURL
          type:(ICImageType)type
          scale:(CGFloat)scale
          cornerRadius:(CGFloat)cornerRadius
          orientation:(BOOL)orientation
          interpolationQuality:(CGInterpolationQuality)quality;

- (void)retriveCachedImage:(NSString *)imageName type:(ICImageType)type completion:(completionBlock)completion;

@end
