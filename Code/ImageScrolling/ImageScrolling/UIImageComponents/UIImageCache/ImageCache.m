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
    [kICImageTypeThumbnailSmall] = @"kICImageThumbnailSmall",
    [kICImageTypeThumbnailMedium] = @"kICImageThumbnailMedium",
    [kICImageTypeThumbnailLarge] = @"kICImageThumbnailLarge",
    [kICImageTypeNormal] = @"kICImageSmall",
    [kICImageTypeMedium] = @"kICImageMedium",
    [kICImageTypeLarge] = @"kICImageLarge",
};

NSString *imageFamilyNames[] = {
    [kICImageTypeThumbnailSmall] = @"ICThumbnailImages",
    [kICImageTypeThumbnailMedium] = @"ICThumbnailImages",
    [kICImageTypeThumbnailLarge] = @"ICThumbnailImages",
    [kICImageTypeNormal] = @"ICRegularImages",
    [kICImageTypeMedium] = @"ICRegularImages",
    [kICImageTypeLarge] = @"ICRegularImages",
};

@interface ImageCache()<FICImageCacheDelegate>

@property(nonatomic, strong)FICImageCache *imageCache;
@property(nonatomic ,strong)NSMutableArray *imageFormats;
@property(nonatomic ,strong)NSMutableArray *imageEntities;

@end

@implementation ImageCache

- (id)init{
    self = [super init];
    
    if(self)
    {
        _isConfiguring = YES;
        self.imageFormats = [NSMutableArray array];
        self.imageEntities = [NSMutableArray array];
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

- (CGSize)formatSize:(NSString *)formatName
{
    CGSize size = CGSizeZero;
    for (FICImageFormat *format in self.imageFormats)
    {
        if([formatName isEqualToString:format.name])
        {
            size = format.imageSize;
        }
    }
    
    return size;
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
- (void)cacheImage:(NSString *)imageName imageURL:(NSURL *)imageURL type:(ICImageType)type
{
    // create a new image entity
    ImageEntity *imageEntity = [[ImageEntity alloc]initWithImageURL:imageURL andFormatName:imageFormatNames[type]];
    [imageEntity setImageName:imageName];
    
    // add it to the new image entity array
    [self.imageEntities addObject:imageEntity];
    
    // cache the image
    [self.imageCache setImage:[UIImage imageWithContentsOfFile:[imageURL absoluteString]] forEntity:imageEntity withFormatName:imageFormatNames[type] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        
    }];
}

- (void)cacheImage:(NSString *)imageName
          imageURL:(NSURL *)imageURL
              type:(ICImageType)type
             scale:(CGFloat)scale
      cornerRadius:(CGFloat)cornerRadius
       orientation:(BOOL)orientation
interpolationQuality:(CGInterpolationQuality)quality
{
    // create a new image entity
    ImageEntity *imageEntity = [[ImageEntity alloc]initWithImageURL:imageURL andFormatName:imageFormatNames[type]];
    [imageEntity setImageName:imageName];
    [imageEntity setImageMetaData:[self formatSize:imageFormatNames[type]] scale:scale cornerRadius:cornerRadius orientation:orientation quality:quality];
    
    // add it to the new image entity array
    [self.imageEntities addObject:imageEntity];
    
    // cache the image
    [self.imageCache setImage:[UIImage imageWithContentsOfFile:imageURL.path] forEntity:imageEntity withFormatName:imageFormatNames[type] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
        
    }];
}

- (BOOL)imageExist:(NSString *)imageName type:(ICImageType)type
{
    BOOL imageExists = NO;
    
    for (ImageEntity *entity in self.imageEntities)
    {
        if([entity.imageName isEqualToString:imageName] && [entity.imageFormatName isEqualToString:imageFormatNames[type]])
        {
            // the image is cached
            // this is a synchronous call
            imageExists = YES;
            break;
        }
    }
    
    return imageExists;
}

- (void)deleteCachedImage:(NSString *)imageName type:(ICImageType)type deleteCompletion:(deleteCompletionBlock)deleteCompletion
{
    BOOL imageExists = NO;
    
    for (ImageEntity *entity in self.imageEntities)
    {
        if([entity.imageName isEqualToString:imageName] && [entity.imageFormatName isEqualToString:imageFormatNames[type]])
        {
            // the image is cached
            // this is a synchronous call
            [self.imageCache deleteImageForEntity:entity withFormatName:imageFormatNames[type]];
            imageExists = [self.imageCache imageExistsForEntity:entity withFormatName:imageFormatNames[type]];
            deleteCompletion(entity.imageName, !imageExists);
            return;
        }
    }
    
    deleteCompletion(nil, !imageExists);
}


- (void)deleteCachedImage:(NSString *)imageName imageURL:(NSURL *)image type:(ICImageType)type deleteCompletion:(deleteCompletionBlock)deleteCompletion
{
    BOOL imageExists = NO;
    
    // create a entity pointing to the image first
    ImageEntity *imageEntity = [[ImageEntity alloc]initWithImageURL:image andFormatName:imageFormatNames[type]];
    
    // the image is cached
    // this is a synchronous call
    [self.imageCache deleteImageForEntity:imageEntity withFormatName:imageFormatNames[type]];
    imageExists = [self.imageCache imageExistsForEntity:imageEntity withFormatName:imageFormatNames[type]];
    deleteCompletion(imageEntity.imageName, !imageExists);
}


- (void)retriveCachedImage:(NSString *)imageName type:(ICImageType)type completion:(completionBlock)completion
{
    for (ImageEntity *entity in self.imageEntities)
    {
        if([entity.imageName isEqualToString:imageName] && [entity.imageFormatName isEqualToString:imageFormatNames[type]])
        {
            // the image is cached
            // this is a synchronous call
            [self.imageCache retrieveImageForEntity:entity withFormatName:imageFormatNames[type] completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
                completion(image, YES);
            }];
            break;
        }
    }
}

#pragma mark - FICImageCacheDelegate
- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id <FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock
{
    completionBlock([(ImageEntity *)entity entityImage]);
}

@end
