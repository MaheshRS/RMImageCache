//
//  UIImage+ImageOrientation.h
//  ImageScrolling
//
//  Created by Mahesh on 2/15/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageOrientation)

- (CGAffineTransform)transformForImage:(UIImageOrientation)imageOrientation
                                  size:(CGSize)imageSize
                               context:(CGContextRef)ctx;

@end
