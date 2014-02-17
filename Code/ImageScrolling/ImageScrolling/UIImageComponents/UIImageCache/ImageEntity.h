//
//  ImageEntity.h
//  ImageScrolling
//
//  Created by Mahesh on 2/16/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICEntity.h"

@interface ImageEntity : NSObject <FICEntity>

@property(nonatomic, strong, readonly)NSURL *imageUrl;
@property(nonatomic, strong, readonly)NSString *imageName;
@property(nonatomic, assign, readonly)NSString *imageFormatName;

@property(nonatomic, assign, readonly)CGSize size;
@property(nonatomic, assign, readonly)CGFloat scale;
@property(nonatomic, assign, readonly)CGFloat cornerRadius;
@property(nonatomic, assign, readonly)BOOL orientation;
@property(nonatomic, assign, readonly)CGInterpolationQuality imageInterpolationQuality;

- (id)initWithImageURL:(NSURL *)imageURL andFormatName:(NSString *)formatName;
- (UIImage *)entityImage;
- (void)setImageName:(NSString *)imageName;
- (void)setImageMetaData:(CGSize)size scale:(CGFloat)scale cornerRadius:(CGFloat)cornerRadius orientation:(BOOL)orientation quality:(CGInterpolationQuality)quality;


@end
