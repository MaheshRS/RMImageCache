//
//  UIImage+Transparancy.m
//  ImageScrolling
//
//  Created by Mahesh on 2/15/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "UIImage+Transparancy.h"

@implementation UIImage (Transparancy)

#pragma mark - Alpha Check
- (BOOL)hasAlpha
{
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    return ((alphaInfo == kCGImageAlphaFirst)
            || (alphaInfo == kCGImageAlphaPremultipliedFirst)
            || (alphaInfo == kCGImageAlphaLast)
            ||(alphaInfo == kCGImageAlphaPremultipliedLast));
}

#pragma mark - Public Available Methods
- (UIImage *)imageWithAlpha
{
    if([self hasAlpha])
        return self;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, self.size.width, self.size.height, CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef img = CGBitmapContextCreateImage(bitmap);
    UIImage *n_image = [UIImage imageWithCGImage:img
                                           scale:self.scale
                                     orientation:self.imageOrientation];
    
    
    CGContextRelease(bitmap);
    CGImageRelease(img);
    return n_image;
    
}

@end
