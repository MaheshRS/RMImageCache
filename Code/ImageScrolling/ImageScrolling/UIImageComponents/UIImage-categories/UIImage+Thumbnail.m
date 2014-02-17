//
//  UIImage+thumbnail.m
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "UIImage+Thumbnail.h"
#import "UIImage+Resizing.h"
#import "UIImage+Transparancy.h"

@implementation UIImage (Thumbnail)

- (UIImage *)thumbnailImageWithSize:(CGSize)size
{
    return [self resizeImageToSize:size];
}

- (UIImage *)thumbnailImageWithSize:(CGSize)size scale:(CGFloat)scale cornerRadius:(CGFloat)cornerRadius
{
    CGSize n_size = size;
    CGImageRef imageRef = [self imageWithAlpha].CGImage;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, n_size.width * scale, n_size.height * scale, CGImageGetBitsPerComponent(imageRef), 0, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    
    [self roundCorner:cornerRadius size:size scale:scale bitmapContext:bitmap];
    
    UIImage *n_image = [self drawImage:bitmap size:n_size scale:scale rawImage:imageRef];
    CGContextRelease(bitmap);
    
    return n_image;
}

#pragma mark - Draw Image
- (UIImage *)drawImage:(CGContextRef)ctx size:(CGSize)size scale:(CGFloat)scale rawImage:(CGImageRef)rawImage
{
    CGContextDrawImage(ctx, CGRectMake(0, 0, size.width * scale, size.height * scale), rawImage);
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    UIImage *n_image = [UIImage imageWithCGImage:img
                                           scale:[UIScreen mainScreen].scale
                                     orientation:self.imageOrientation];
    
    CGImageRelease(img);
    return n_image;
}

- (void)roundCorner:(CGFloat)cornerRadius size:(CGSize)size scale:(CGFloat)scale bitmapContext:(CGContextRef)ctx
{
    CGRect boundingRect = CGRectMake(0, 0, size.width * scale, size.height * scale);
    CGContextSaveGState(ctx);
    
    CGContextBeginPath(ctx);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:boundingRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius * scale, cornerRadius * scale)];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClosePath(ctx);
    CGContextAddPath(ctx, path.CGPath);
    
    CGContextRestoreGState(ctx);
    CGContextClip(ctx);
}

@end
