//
//  MPViewController.m
//  ImageScrolling
//
//  Created by Mahesh on 2/14/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "MPViewController.h"
#import "CustomCell.h"
#import "CustomCell.h"
#import "UIImage+Resizing.h"
#import "UIImage+Thumbnail.h"
#import "ImageCache.h"

#import "MPListViewController.h"

@interface MPViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)ImageCache *imageCache;

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageArray = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"18",@"19",@"20",@"21"]];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    // init the image cache
    [self initImageCache];
    
    // clear the previous images and cache the new one
    [self clearImageCache];
    [self cacheImage];
    
    [[self tableView]reloadData];
    
    // TOOD: Handles deletion, for now only commenting this will need in future development.
    /*typeof(self) __weak weakself = self;
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.imageArray.count];
        [self.imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             // cache the image
             [weakself.imageCache deleteCachedImage:(NSString *)obj type:kICImageTypeThumbnailLarge deleteCompletion:^(NSString *imageName, BOOL success) {
                 if(success)
                 {
                     [array addObject:obj];
                 }
             }];
         }];
        
        for(NSString *str in array)
        {
            [weakself.imageArray removeObject:str];
        }
        
        [array removeAllObjects];
        array = nil;
        
        [weakself.tableView reloadData];
    });*/
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (void)initImageCache
{
    self.imageCache = [[ImageCache alloc]init];
    [self.imageCache configureImageType:kICImageTypeThumbnailLarge imageStyle:kICmageFormatStyle32BitBGRA withSize:CGSizeMake(40, 40)];
    [self.imageCache configureImageType:kICImageTypeNormal imageStyle:kICmageFormatStyle32BitBGRA withSize:CGSizeMake(202, 202)];
    [self.imageCache finishConfiguringImageCache];
}

- (void)clearImageCache
{
    for (NSString *string in self.imageArray)
    {
        // cache the image
        NSURL *imageUrl = [[NSBundle mainBundle]URLForResource:string withExtension:@"jpg"];
        [self.imageCache deleteCachedImage:string imageURL:imageUrl type:kICImageTypeThumbnailLarge deleteCompletion:^(NSString *imageName, BOOL success) {
            
        }];
        
        [self.imageCache deleteCachedImage:string imageURL:imageUrl type:kICImageTypeNormal deleteCompletion:^(NSString *imageName, BOOL success) {
            
        }];
    }
}

- (void)cacheImage
{
    for (NSString *string in self.imageArray)
    {
        // cache the image
        NSURL *imageUrl = [[NSBundle mainBundle]URLForResource:string withExtension:@"jpg"];
        [self.imageCache cacheImage:string imageURL:imageUrl type:kICImageTypeThumbnailLarge scale:[UIScreen mainScreen].scale cornerRadius:20.0f orientation:NO interpolationQuality:kCGInterpolationHigh];
        [self.imageCache cacheImage:string imageURL:imageUrl type:kICImageTypeNormal scale:[UIScreen mainScreen].scale cornerRadius:0.0f orientation:NO interpolationQuality:kCGInterpolationHigh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArray.count * 200;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:[NSObject class] options:nil] objectAtIndex:0];
    }
    
    NSString *random1 = [NSString stringWithFormat:@"%d",(int)(indexPath.row +1)%21];
    NSString *random2 = [NSString stringWithFormat:@"%d",(int)(indexPath.row+2)%21];
    NSString *random3 = [NSString stringWithFormat:@"%d",(int)(indexPath.row+3)%21];
    
    [self.imageCache retriveCachedImage:random1 type:kICImageTypeThumbnailLarge completion:^(UIImage *image, BOOL success) {
        NSAssert(image!=nil, @"Image Cannot be nil");
        cell.profilePic.image = image;
    }];
    [self.imageCache retriveCachedImage:random2 type:kICImageTypeThumbnailLarge completion:^(UIImage *image, BOOL success) {
        NSAssert(image!=nil, @"Image Cannot be nil");
        cell.profilePic1.image = image;
    }];
    [self.imageCache retriveCachedImage:random3 type:kICImageTypeThumbnailLarge completion:^(UIImage *image, BOOL success) {
        NSAssert(image!=nil, @"Image Cannot be nil");
        cell.profilePIc2.image = image;
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MPListViewController *listViewController = [storyBoard instantiateViewControllerWithIdentifier:@"ListStyleController"];
    
    if(listViewController)
    {
        listViewController.imageCache = self.imageCache;
       [self.navigationController pushViewController:listViewController animated:YES];
    }
}

@end
