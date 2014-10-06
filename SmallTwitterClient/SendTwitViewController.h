//
//  SendTwitViewController.h
//  SmallTwitterClient
//
//  Created by Gorf on 10/4/14.
//  Copyright (c) 2014 Gorf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTwitterAPI.h"

@interface SendTwitViewController : UIViewController<UITextViewDelegate>

@property (nonatomic, strong) STTwitterAPI *twitter;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrTop;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;
@property (weak, nonatomic) IBOutlet UITextView *txtText;
- (IBAction)TweetAction:(id)sender;
- (IBAction)TouchInterceptAction:(id)sender;

@end
