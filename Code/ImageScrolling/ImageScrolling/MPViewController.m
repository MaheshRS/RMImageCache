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

@interface MPViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)ImageCache *imageCache;

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"];
    self.tableView.backgroundColor = [UIColor grayColor];
    
    // init the image cache
    [self initImageCache];
    
    for (NSString *string in self.imageArray)
    {
        // cache the image
        [self.imageCache cacheImage:string imageURL:[[NSBundle mainBundle] URLForResource:string withExtension:@"jpg"] type:kICImageTypeThumbnailLarge scale:[UIScreen mainScreen].scale cornerRadius:20.0f orientation:NO interpolationQuality:kCGInterpolationHigh];
    }
    
    [[self tableView]reloadData];
}

- (void)initImageCache
{
    self.imageCache = [[ImageCache alloc]init];
    [self.imageCache configureImageType:kICImageTypeThumbnailLarge imageStyle:kICmageFormatStyle32BitBGRA withSize:CGSizeMake(40, 40)];
    [self.imageCache finishConfiguringImageCache];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:[NSObject class] options:nil] objectAtIndex:0];
    }
    
    NSString *random1 = [NSString stringWithFormat:@"%d",(indexPath.row +1)%13];
    NSString *random2 = [NSString stringWithFormat:@"%d",(indexPath.row +2)%13];
    NSString *random3 = [NSString stringWithFormat:@"%d",(indexPath.row +3)%13];
    
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

@end
