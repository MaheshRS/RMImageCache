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
@property(nonatomic, assign, readonly)UIImage *updatedImage;

- (id)initWithImageURL:(NSURL *)imageURL andFormatName:(NSString *)formatName;
- (void)setImageName:(NSString *)imageName;
- (void)setUpdatedImage:(UIImage *)updatedImage;

@end
