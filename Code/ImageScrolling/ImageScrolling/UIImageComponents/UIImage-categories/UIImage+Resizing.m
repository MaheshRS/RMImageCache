//
//  UIImage+Resizing.m
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "UIImage+Resizing.h"
#import "UIImage+ImageOrientation.h"

@implementation UIImage (Resizing)

#pragma mark - Public Available API's
- (UIImage *)resizeImageToSize:(CGSize)size
{
   return [self resizeImageToSize:size interpolationQuality:kCGInterpolationHigh scale:[UIScreen mainScreen].scale orientation:NO];
}

- (UIImage *)resizeImageToSize:(CGSize)size orientation:(BOOL)up
{
    return [self resizeImageToSize:size interpolationQuality:kCGInterpolationHigh scale:[UIScreen mainScreen].scale orientation:up];
}

#pragma mark - Actual Resize
- (UIImage *)resizeImageToSize:(CGSize)size interpolationQuality:(CGInterpolationQuality)quality scale:(CGFloat)scale orientation:(BOOL)up
{
    if((size.width == 0) && (size.height == 0))
        return self;
    
    CGSize n_size = size;
    CGImageRef imageRef = self.CGImage;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, n_size.width * scale, n_size.height * scale, CGImageGetBitsPerComponent(imageRef), 0, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    
    if(up)
        CGContextConcatCTM(bitmap, [self transfomImageOrientation:bitmap size:size]);
    
    UIImage *n_image = [self drawImage:bitmap size:n_size scale:scale rawImage:imageRef];
    CGContextRelease(bitmap);
    
    return n_image;
}

- (UIImage *)resizeImageToSize:(CGSize)size interpolationQuality:(CGInterpolationQuality)quality sharptype:(UIImageSharpningType)type scale:(CGFloat)scale orientation:(BOOL)up
{
    if((size.width == 0) && (size.height == 0))
        return self;
    
    UIImage *n_image = [self sharpenImage:self type:type size:size scale:scale];
    return n_image;
}

- (UIImage *)resizeImageToSize:(CGSize)size sharptype:(UIImageSharpningType)type interpolationQuality:(CGInterpolationQuality)quality scale:(CGFloat)scale orientation:(BOOL)up
{
    UIImage *img = [self resizeImageToSize:size interpolationQuality:quality sharptype:kSimpleSharp scale:scale orientation:up];
    
    return img;
}

#pragma mark - Draw Image
- (UIImage *)drawImage:(CGContextRef)ctx size:(CGSize)size scale:(CGFloat)scale rawImage:(CGImageRef)rawImage
{
    CGContextDrawImage(ctx, CGRectMake(0, 0, size.width * scale, size.height  * scale), rawImage);
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    UIImage *n_image = [UIImage imageWithCGImage:img
                                           scale:[UIScreen mainScreen].scale
                                     orientation:self.imageOrientation];
    
    CGImageRelease(img);
    return n_image;
}

- (CGAffineTransform)transfomImageOrientation:(CGContextRef)bitmap size:(CGSize)size
{
    return [self transformForImage:self.imageOrientation size:size context:bitmap];
}

@end
