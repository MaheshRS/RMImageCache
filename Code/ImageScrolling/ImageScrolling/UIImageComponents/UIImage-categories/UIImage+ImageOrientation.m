//
//  UIImage+ImageOrientation.m
//  ImageScrolling
//
//  Created by Mahesh on 2/15/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "UIImage+ImageOrientation.h"

@implementation UIImage (ImageOrientation)

- (CGAffineTransform)transformForImage:(UIImageOrientation)imageOrientation
                                  size:(CGSize)imageSize
                               context:(CGContextRef)ctx
{
    CGAffineTransform transform = CGContextGetCTM(ctx) ;
    
    switch (imageOrientation) {
        case UIImageOrientationUp:
            break;
        case UIImageOrientationDown:
            CGContextTranslateCTM(ctx, imageSize.width, imageSize.height);
            CGContextRotateCTM(ctx, M_PI);
            break;
        case UIImageOrientationUpMirrored:
            CGContextTranslateCTM(ctx, imageSize.width, 0);
            CGContextScaleCTM(ctx, -1, 1);
            break;
        case UIImageOrientationDownMirrored:
            CGContextTranslateCTM(ctx, 0, imageSize.height);
            CGContextScaleCTM(ctx, 1, -1);
            break;
        case UIImageOrientationLeft:
            CGContextTranslateCTM(ctx, 0, imageSize.height);
            CGContextRotateCTM(ctx, -M_PI_2);
            break;
        case UIImageOrientationLeftMirrored:
            CGContextTranslateCTM(ctx, 0, imageSize.height);
            CGContextScaleCTM(ctx, 1, -1);
            CGContextTranslateCTM(ctx, imageSize.width, 0);
            CGContextRotateCTM(ctx, M_PI_2);
            break;
        case UIImageOrientationRight:
            CGContextTranslateCTM(ctx, 0, imageSize.height);
            CGContextRotateCTM(ctx, -M_PI_2);
            break;
        case UIImageOrientationRightMirrored:
            CGContextTranslateCTM(ctx, 0, imageSize.height);
            CGContextScaleCTM(ctx, 1, -1);
            CGContextTranslateCTM(ctx, imageSize.width,0);
            CGContextRotateCTM(ctx, M_PI);
            break;
        default:
            break;
    }
    
    return transform;
}

@end
