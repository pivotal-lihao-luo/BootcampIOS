//
//  BCTableViewCell.m
//  Bootcamp
//
//  Created by DEV FLOATER 33 on 9/11/14.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import "BCTableViewCell.h"

@implementation BCTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
