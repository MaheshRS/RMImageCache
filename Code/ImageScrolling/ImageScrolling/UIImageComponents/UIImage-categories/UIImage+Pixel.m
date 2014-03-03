//
//  UIImage+Pixel.m
//  ImageScrolling
//
//  Created by Mahesh on 2/28/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "UIImage+Pixel.h"

@implementation UIImage (Pixel)

- (UIImage *)simpleSharp:(UIImage *)image  size:(CGSize)size scale:(CGFloat)scale
{
    CGImageRef imageRef = image.CGImage;
    NSUInteger imageWidth = size.width * scale;
    NSUInteger imageHeight = size.height * scale;
    CGSize n_size = CGSizeMake(imageWidth, imageHeight);
    
    if((n_size.width == 0) && (n_size.height == 0))
        return self;
    
    unsigned char *originalData = malloc(imageWidth * imageHeight * 4);
    unsigned char *manipulatedData = malloc(imageWidth * imageHeight * 4);
    NSUInteger totalCount = (imageWidth * imageHeight * 4);
    
    CGContextRef bitmap = CGBitmapContextCreate(originalData, n_size.width, n_size.height, 8, 4 * n_size.width, CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationNone);
    
    
    UIImage *n_image = [self drawImage:bitmap size:n_size rawImage:imageRef];
    CGContextRelease(bitmap);
    
    NSInteger byteIdx = 0;
    for (NSInteger i = 0; i < (imageHeight * imageWidth); i++)
    {
        //int output = (manipulatedData[byteIdx] + manipulatedData[byteIdx+1] + manipulatedData[byteIdx+2])/3;
        
        // simple sharpning algorithm
        //Lsharp(x) = [ L(x) - (ksharp /2) * (L(x-V) + L(x+V)) ] / (1- ksharp )
        
        CGFloat sharpFactor = 0.1;
        CGFloat scanRate = (60 * (n_size.width) * (n_size.height));
        CGFloat pixelShift = (1 * 4) * (1/scanRate);
        int r_output = originalData[byteIdx];
        int g_output = originalData[byteIdx + 1];
        int b_output = originalData[byteIdx +2];
        
        int r_output_prev = 0;
        int g_output_prev = 0;
        int b_output_prev = 0;

        int r_output_next = 0;
        int g_output_next = 0;
        int b_output_next = 0;
        
        signed int index = (int)byteIdx;
        
        index = (byteIdx - pixelShift);
        if(index >= 0)
        {
            // previous pixel
            r_output_prev = originalData[index];
            g_output_prev = originalData[index+1];
            b_output_prev = originalData[index+2];
        }
        
        index = (byteIdx + pixelShift);
        if(index <= totalCount)
        {
            // bottom pixel
            r_output_next = originalData[index];
            g_output_next = originalData[index+1];
            b_output_next = originalData[index+2];
        }

        r_output = (r_output - (sharpFactor/2) * (r_output_next + r_output_prev))/(1 - sharpFactor);
        g_output = (g_output - (sharpFactor/2) * (g_output_next + g_output_prev))/(1 - sharpFactor);
        b_output = (b_output - (sharpFactor/2) * (b_output_next + b_output_prev))/(1 - sharpFactor);
        
        manipulatedData[byteIdx] = (char)r_output;
        manipulatedData[byteIdx+1] = (char)g_output;
        manipulatedData[byteIdx+2] = (char)b_output;
        
        r_output = 0;
        g_output = 0;
        b_output = 0;
        
        byteIdx += 4;
    }
    
    n_image = [self drawImageWithSize:n_size rawData:manipulatedData rawImage:n_image.CGImage];
    
    free(originalData);
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

#pragma mark - Sharpning Image Techiniques
- (UIImage *)sharpenImage:(UIImage *)image type:(UIImageSharpningType)type size:(CGSize)size scale:(CGFloat)scale
{
    switch (type)
    {
        case kSimpleSharp:
            return [self simpleSharp:image size:size scale:scale];
            break;
        default:
            return [self simpleSharp:image size:size scale:scale];
            break;
    }
}

@end
