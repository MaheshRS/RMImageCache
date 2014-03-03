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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
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
    
    NSString *random1 = [NSString stringWithFormat:@"%d",(int)(indexPath.row+1)%21];
    
    [self.imageCache retriveCachedImage:random1 type:kICImageTypeNormal completion:^(UIImage *image, BOOL success) {
        NSAssert(image!=nil, @"Image Cannot be nil");
        cell.listImageView.image = image;
    }];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
