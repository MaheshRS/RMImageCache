//
//  UIImage+Pixel.m
//  ImageScrolling
//
//  Created by Mahesh on 2/28/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "UIImage+Pixel.h"

@implementation UIImage (Pixel)

- (UIImage *)grayScaledImage:(UIImage *)image
{
    CGImageRef imageRef = image.CGImage;
    NSUInteger imageWidth = CGImageGetWidth(imageRef);
    NSUInteger imageHeight = CGImageGetHeight(imageRef);
    CGSize n_size = CGSizeMake(imageWidth, imageHeight);
    
    if((n_size.width == 0) && (n_size.height == 0))
        return self;
    
    unsigned char *manipulatedData = malloc(imageWidth * imageHeight * 4);
    
    CGContextRef bitmap = CGBitmapContextCreate(manipulatedData, n_size.width, n_size.height, 8, 4 * n_size.width, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    
    
    UIImage *n_image = [self drawImage:bitmap size:n_size rawImage:imageRef];
    CGContextRelease(bitmap);
    
    NSInteger byteIdx = 0;
    for (NSInteger i = 0; i < (imageHeight * imageWidth); i++)
    {
        int output = (manipulatedData[byteIdx] + manipulatedData[byteIdx+1] + manipulatedData[byteIdx+2])/3;
        manipulatedData[byteIdx] = (char)output;
        manipulatedData[byteIdx+1] = (char)output;
        manipulatedData[byteIdx+2] = (char)output;
        
        byteIdx += 4;
    }
    
    n_image = [self drawImageWithSize:n_size rawData:manipulatedData rawImage:n_image.CGImage];
    
    free(manipulatedData);
    
    return n_image;
}

#pragma mark - Draw Image
- (UIImage *)drawImage:(CGContextRef)ctx size:(CGSize)size rawImage:(CGImageRef)rawImage
{
    CGContextDrawImage(ctx, CGRectMake(0, 0, size.width, size.height), rawImage);
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    UIImage *n_image = [UIImage imageWithCGImage:img
                                           scale:1
                                     orientation:self.imageOrientation];
    
    CGImageRelease(img);
    return n_image;
}

- (UIImage *)drawImageWithSize:(CGSize)size rawData:(unsigned char *)rawData rawImage:(CGImageRef)rawImage
{
    CGContextRef bitmap = CGBitmapContextCreate(rawData, size.width, size.height, 8, 4 * size.width, CGImageGetColorSpace(rawImage), CGImageGetBitmapInfo(rawImage));
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    
    
    CGImageRef img = CGBitmapContextCreateImage(bitmap);
    UIImage *n_image = [UIImage imageWithCGImage:img
                                           scale:1
                                     orientation:self.imageOrientation];
    
    CGImageRelease(img);
    CGContextRelease(bitmap);
    
    return n_image;
}

@end
