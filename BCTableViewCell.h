//
//  BCTableViewCell.h
//  Bootcamp
//
//  Created by DEV FLOATER 33 on 9/11/14.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *detailsText;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

@end
