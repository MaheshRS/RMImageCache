//
//  ImageEntity.m
//  ImageScrolling
//
//  Created by Mahesh on 2/16/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "ImageEntity.h"
#import "FICUtilities.h"

@interface ImageEntity()

@property(nonatomic, strong)NSString *U_UID;

@end

@implementation ImageEntity
- (id)initWithImageURL:(NSURL *)imageURL andFormatName:(NSString *)formatName
{
    self = [super init];
    if(self)
    {
        _imageUrl = imageURL;
        _imageFormatName = formatName;
    }
    
    return self;
}

#pragma mark - FICEntity Protocol Implementation
#pragma mark - FICImageCacheEntity

- (NSString *)UUID {
    if (self.UUID == nil) {
        // MD5 hashing is expensive enough that we only want to do it once
        CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString([self.imageUrl absoluteString]);
        self.U_UID = FICStringWithUUIDBytes(UUIDBytes);
    }
    
    return self.U_UID;
}

- (NSString *)sourceImageUUID {
    return [self U_UID];
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    return self.imageUrl;
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef contextRef, CGSize contextSize) {
        CGRect contextBounds = CGRectMake(0, 0, contextSize.width, contextSize.height);
        [image drawInRect:contextBounds];
    };
    
    return drawingBlock;
}

@end
