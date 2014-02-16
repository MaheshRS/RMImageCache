//
//  ImageCache.m
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "ImageCache.h"
#import "FICImageFormat.h"
#import "FICImageCache.h"
#import "ImageEntity.h"

NSString *imageFormatNames[] = {
    [kICImageThumbnailSmall] = @"kICImageThumbnailSmall",
    [kICImageThumbnailMedium] = @"kICImageThumbnailMedium",
    [kICImageThumbnailLarge] = @"kICImageThumbnailLarge",
    [kICImageNormal] = @"kICImageSmall",
    [kICImageMedium] = @"kICImageMedium",
    [kICImageLarge] = @"kICImageLarge",
};

NSString *imageFamilyNames[] = {
    [kICImageThumbnailSmall] = @"ICThumbnailImages",
    [kICImageThumbnailMedium] = @"ICThumbnailImages",
    [kICImageThumbnailLarge] = @"ICThumbnailImages",
    [kICImageNormal] = @"ICRegularImages",
    [kICImageMedium] = @"ICRegularImages",
    [kICImageLarge] = @"ICRegularImages",
};

@interface ImageCache()<FICImageCacheDelegate>

@property(nonatomic, strong)FICImageCache *imageCache;
@property(nonatomic ,strong)NSMutableArray *imageFormats;

@end

@implementation ImageCache

- (id)init{
    self = [super init];
    
    if(self)
    {
        _isConfiguring = YES;
        self.imageFormats = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Image Format Configuration
- (void)configureImageType:(ICImageType)imageType imageStyle:(ICImageStyle)style withSize:(CGSize)size
{
    // if the cache is already built! No more format support can be added.
    NSAssert(_isConfiguring, @"You cannot add a new image format after the image cache is built. Please add the format at the time of configuring the cache.");
    
    // check if the configuration for the imagetype and imageStyle already exists
    // if it exists then assert else add it to the image formats.
    for (FICImageFormat *format in self.imageFormats)
    {
            NSAssert(![imageFormatNames[imageType] isEqualToString:format.name], @"Caching for this format is already initiaized");
    }
    
    // add the new image format to the list of other image formatters;
    [self.imageFormats addObject:[self imageFormatWithType:imageType imageStyle:style withSize:size]];
}

- (FICImageFormat *)imageFormatWithType:(ICImageType)type imageStyle:(ICImageStyle)style withSize:(CGSize)size
{
    // initiate the new formatters
    FICImageFormat *imageFormat = [[FICImageFormat alloc]init];
    imageFormat.name = imageFormatNames[type];
    imageFormat.family = imageFamilyNames[type];
    imageFormat.style = [self FICStyleForICStyle:style];
    imageFormat.imageSize = size;
    imageFormat.maximumCount = 250;
    imageFormat.devices = [self currentDeviceIdiom];
    
    return imageFormat;
}

#pragma mark - Finish Configuration
- (void)finishConfiguringImageCache
{
    // It is wrong to finish the image configuration without the any format configuration
    NSAssert((self.imageFormats.count>0), @"You need to Configure atleast one image format to use the image cache.");
    
    // now we have all the formatters and build the image cache with these formatters
    _isConfiguring = NO;
    [self buildCache];
}

#pragma mark - Build the image FICImageCache
- (void)buildCache
{
    self.imageCache = [[FICImageCache alloc]init];
    self.imageCache.delegate = self;
    [self.imageCache setFormats:[NSArray arrayWithArray:self.imageFormats]];
}


#pragma mark - Style Helper Methods
- (FICImageFormatStyle)FICStyleForICStyle:(ICImageStyle)ICImageStyle
{
    switch (ICImageStyle) {
        case kICmageFormatStyle32BitBGRA:
            return FICImageFormatStyle32BitBGRA;
            break;
        case kICImageFormatStyle32BitBGR:
            return FICImageFormatStyle32BitBGR;
            break;
        case kICImageFormatStyle16BitBGR:
            return FICImageFormatStyle16BitBGR;
            break;
        case kICImageFormatStyle8BitGrayscale:
            return FICImageFormatStyle8BitGrayscale;
            break;
        default:
            return FICImageFormatStyle32BitBGRA;
            break;
    }
}

- (NSString *)formatNameForStyle:(ICImageType)type
{
    return imageFormatNames[type];
}

#pragma mark - Idiom Herper Methods
- (FICImageFormatDevices)currentDeviceIdiom
{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        return FICImageFormatDevicePhone;
    else
        return FICImageFormatDevicePad;
}

#pragma mark - Cache Images
- (void)cacheImage:(NSString *)imageName imageURL:(NSURL *)imageURL style:(ICImageType)type
{
    //ImageEntity *imageEntity = [[ImageEntity alloc]initWithImageURL:imageURL andFormatName:imageFormatNames[type]];
}

@end
