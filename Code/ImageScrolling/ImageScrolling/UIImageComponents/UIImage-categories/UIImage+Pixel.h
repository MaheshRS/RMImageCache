//
//  UIImage+Pixel.h
//  ImageScrolling
//
//  Created by Mahesh on 2/28/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kSimpleSharp=0,
}UIImageSharpningType;

@interface UIImage (Pixel)

- (UIImage *)sharpenImage:(UIImage *)image type:(UIImageSharpningType)type size:(CGSize)size scale:(CGFloat)scale;

@end
