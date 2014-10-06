//
//  TimelineCell.m
//  SmallTwitterClient
//
//  Created by Gorf on 10/6/14.
//  Copyright (c) 2014 Gorf. All rights reserved.
//

#import "TimelineCell.h"

@implementation TimelineCell

- (void)awakeFromNib {
    _lblTitle.layer.cornerRadius=8.0f;
    _lblTitle.layer.masksToBounds=FALSE;
    _lblTitle.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _lblTitle.layer.borderWidth= 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
