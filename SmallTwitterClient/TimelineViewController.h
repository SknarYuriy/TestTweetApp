//
//  TimelineViewController.h
//  SmallTwitterClient
//
//  Created by Gorf on 10/4/14.
//  Copyright (c) 2014 Gorf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendTwitViewController.h"

@interface TimelineViewController : UIViewController<UITableViewDataSource>

@property (nonatomic, strong) NSArray *statuses;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cnstrTop;

- (IBAction)LoginiOSAction:(id)sender;
- (IBAction)LoginWEBAction:(id)sender;
- (IBAction)TimelineAction:(id)sender;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier;

@end
