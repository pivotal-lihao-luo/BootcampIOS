//
//  BCSongData.h
//  Bootcamp
//
//  Created by DEV FLOATER 33 on 9/10/14.
//  Copyright (c) 2014 Pivotal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCSearchController.h"

@interface BCSongData : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *songID;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *album;
@property (nonatomic, strong) NSString *albumID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString* ref_type;
@end
