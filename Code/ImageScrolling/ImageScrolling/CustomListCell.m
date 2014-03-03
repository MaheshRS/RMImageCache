//
//  CustomListCell.m
//  ImageScrolling
//
//  Created by Mahesh on 3/3/14.
//  Copyright (c) 2014 Mahesh Shanbhag. All rights reserved.
//

#import "CustomListCell.h"

@implementation CustomListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
