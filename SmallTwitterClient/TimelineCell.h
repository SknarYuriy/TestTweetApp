//
//  TimelineCell.h
//  SmallTwitterClient
//
//  Created by Gorf on 10/6/14.
//  Copyright (c) 2014 Gorf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSubTitle;

@end
