//
//  UIImage+Resizing.h
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Pixel.h"

@interface UIImage (Resizing)

- (UIImage *)resizeImageToSize:(CGSize)size;
- (UIImage *)resizeImageToSize:(CGSize)size orientation:(BOOL)up;
- (UIImage *)resizeImageToSize:(CGSize)size interpolationQuality:(CGInterpolationQuality)quality scale:(CGFloat)scale orientation:(BOOL)up;
- (UIImage *)resizeImageToSize:(CGSize)size sharptype:(UIImageSharpningType)type interpolationQuality:(CGInterpolationQuality)quality scale:(CGFloat)scale orientation:(BOOL)up;

@end
