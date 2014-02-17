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

@interface MPViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray *imageArray;

@end

@implementation MPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.imageArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13"];
    
    self.tableView.backgroundColor = [UIColor grayColor];
    
    for (NSString *string in self.imageArray)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:string ofType:@"jpg"]];
        img = [img thumbnailImageWithSize:CGSizeMake(40, 40) scale:[UIScreen mainScreen].scale cornerRadius:20];
        /*[[YMLImageCache sharedImageCache]storeImage:img forKey:string toDisk:NO];*/
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
    return 1000;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:[NSObject class] options:nil] objectAtIndex:0];
    }
    
    /*NSInteger random1 = arc4random()%13;
    NSInteger random2 = arc4random()%13;
    NSInteger random3 = arc4random()%13;
    
    cell.profilePic.image = [[YMLImageCache sharedImageCache]imageFromKey:self.imageArray[random1] fromDisk:NO];
    cell.profilePic1.image = [[YMLImageCache sharedImageCache]imageFromKey:self.imageArray[random2] fromDisk:NO];
    cell.profilePIc2.image = [[YMLImageCache sharedImageCache]imageFromKey:self.imageArray[random3] fromDisk:NO];*/
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
