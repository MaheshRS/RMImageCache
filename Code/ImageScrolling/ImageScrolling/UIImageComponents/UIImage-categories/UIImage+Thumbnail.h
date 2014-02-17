//
//  UIImage+thumbnail.h
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Thumbnail)

- (UIImage *)thumbnailImageWithSize:(CGSize)size;
- (UIImage *)thumbnailImageWithSize:(CGSize)size scale:(CGFloat)scale cornerRadius:(CGFloat)cornerRadius;

@end
