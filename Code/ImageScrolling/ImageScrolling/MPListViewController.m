//
//  MPListViewController.m
//  ImageScrolling
//
//  Created by Mahesh on 3/3/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "MPListViewController.h"
#import "CustomListCell.h"
#import "ImageCache.h"

@interface MPListViewController ()

@property (nonatomic, strong)NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation MPListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.imageArray = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"18",@"19",@"20",@"21"]];
    self.listTableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self clearImageCache];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

#pragma mark - Clear Cache
- (void)clearImageCache
{
    for (NSString *string in self.imageArray)
    {
        // cache the image
        NSURL *imageUrl = [[NSBundle mainBundle]URLForResource:string withExtension:@"jpg"];
        [self.imageCache deleteCachedImage:string imageURL:imageUrl type:kICImageTypeNormal deleteCompletion:^(NSString *imageName, BOOL success) {
            
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.imageArray.count * 200;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseListCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomListCell" owner:[NSObject class] options:nil] objectAtIndex:0];
    }
    
    NSString *random1 = [NSString stringWithFormat:@"%d",(int)(indexPath.row+1)%20];
    random1 = self.imageArray[[random1 integerValue]];
    
    if([self.imageCache imageExist:random1 type:kICImageTypeNormal])
    {
        [self.imageCache retriveCachedImage:random1 type:kICImageTypeNormal completion:^(UIImage *image, BOOL success) {
            NSAssert(image!=nil, @"Image Cannot be nil");
            cell.listImageView.image = image;
        }];
    }
    else
    {
        [self.imageCache cacheImage:random1 imageURL:[[NSBundle mainBundle] URLForResource:random1 withExtension:@"jpg"] type:kICImageTypeNormal scale:[UIScreen mainScreen].scale cornerRadius:0.0f orientation:NO interpolationQuality:kCGInterpolationHigh];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - Cache Image
- (void)cacheImage:(NSString *)imageName url:(NSURL *)imageUrl
{
    [self.imageCache cacheImage:imageName imageURL:imageUrl type:kICImageTypeNormal scale:[UIScreen mainScreen].scale cornerRadius:0.0f orientation:NO interpolationQuality:kCGInterpolationHigh];
}

@end
