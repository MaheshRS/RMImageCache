//
//  ImageEntity.m
//  ImageScrolling
//
//  Created by Mahesh on 2/16/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "ImageEntity.h"
#import "FICUtilities.h"
#import "UIImage+Thumbnail.h"
#import "UIImage+Resizing.h"

@interface ImageEntity()

@property(nonatomic, strong)NSString *U_UID;

@end

@implementation ImageEntity
- (id)initWithImageURL:(NSURL *)imageURL andFormatName:(NSString *)formatName
{
    self = [super init];
    if(self)
    {
        _imageUrl = imageURL;
        _imageFormatName = formatName;
    }
    
    return self;
}

#pragma mark - Source Image
- (UIImage *)entityImage
{
    return [self metaDataAppliedImage];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName= imageName;
}

- (UIImage *)metaDataAppliedImage
{
    if(self.cornerRadius == 0)
    {
        // normal square Image
        UIImage *image = [UIImage imageWithContentsOfFile:_imageUrl.path];
        image = [image resizeImageToSize:_size orientation:_orientation];
        
        return image;
    }
    else
    {
        // some corner radius is there
        UIImage *image = [UIImage imageWithContentsOfFile:_imageUrl.path];
        image = [image thumbnailImageWithSize:_size scale:_scale cornerRadius:_cornerRadius];
        return image;
    }
}

#pragma mark - Image metadata
- (void)setImageMetaData:(CGSize)size scale:(CGFloat)scale cornerRadius:(CGFloat)cornerRadius orientation:(BOOL)orientation quality:(CGInterpolationQuality)quality
{
    _size = size;
    _scale = scale;
    _cornerRadius = cornerRadius;
    _orientation = orientation;
    _imageInterpolationQuality = quality;
}

#pragma mark - FICEntity Protocol Implementation
#pragma mark - FICImageCacheEntity

- (NSString *)UUID {
    if (self.U_UID == nil) {
        // MD5 hashing is expensive enough that we only want to do it once
        CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString([self.imageUrl absoluteString]);
        self.U_UID = FICStringWithUUIDBytes(UUIDBytes);
    }
    
    return self.U_UID;
}

- (NSString *)sourceImageUUID {
    return [self U_UID];
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    return self.imageUrl;
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef contextRef, CGSize contextSize) {
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        
        UIImage *squareImage = image;
        
        UIGraphicsPushContext(contextRef);
        [squareImage drawInRect:contextBounds];
        UIGraphicsPopContext();
    };
    
    return drawingBlock;
}

@end
