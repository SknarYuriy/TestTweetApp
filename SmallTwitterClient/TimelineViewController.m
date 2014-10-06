//
//  TimelineViewController.m
//  SmallTwitterClient
//
//  Created by Gorf on 10/4/14.
//  Copyright (c) 2014 Gorf. All rights reserved.
//

#import "TimelineViewController.h"
#import "STTwitter.h"
#import "TimelineCell.h"

@interface TimelineViewController ()
@property (nonatomic, strong) STTwitterAPI *twitter;
@end

@implementation TimelineViewController

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.statuses count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"TimelineCell";
    TimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        NSArray *items = [[NSBundle mainBundle] loadNibNamed:@"TimelineCell" owner:self options:NULL];
        for(id item in items)
        {
            if ([item isKindOfClass:[TimelineCell class]])
            {
                cell = item;
                break;
            }
        }
    }

    NSDictionary *status = [self.statuses objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    cell.lblTitle.text = text;
    cell.lblTitle.font = [UIFont fontWithName:cell.lblTitle.font.fontName size:17];
    
    cell.lblSubTitle.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    cell.lblSubTitle.font = [UIFont fontWithName:cell.lblTitle.font.fontName size:13];
    
    return cell;
}


#pragma mark - ViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

//    UIBarButtonItem *btnExit = [[UIBarButtonItem alloc] initWithTitle:@"Exit" style:UIBarButtonItemStylePlain target:self action:@selector(btnExitClick)];
//    [self.navigationItem setLeftBarButtonItem:btnExit];

    UIBarButtonItem *btnSendTweet = [[UIBarButtonItem alloc] initWithTitle:@"Send Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(btnSendTweetClick)];
    [self.navigationItem setRightBarButtonItem:btnSendTweet];
    
    _tableView.dataSource=self;
    
    NSError *error = nil;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] encoding:(NSUnicodeStringEncoding) error:&error];
    if (!locationString)
    {
        [_lblStatus setText:@"   NO INTERNET CONNECTION!!!"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat height = self.navigationController.navigationBar.frame.size.height +
    (statusBarFrame.size.height > statusBarFrame.size.width ? statusBarFrame.size.width : statusBarFrame.size.height);
    [_cnstrTop setConstant:height];
    [self.view layoutIfNeeded];
}


#pragma mark - Events
- (void)btnSendTweetClick
{
    SendTwitViewController *sendTwitViewController = [[SendTwitViewController alloc] initWithNibName:@"SendTwitViewController" bundle:NULL];
    sendTwitViewController.twitter = self.twitter;
    [self.navigationController pushViewController:sendTwitViewController animated:TRUE];
}

- (void)btnExitClick
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                    message:@"Do you want to exit?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)
    {
        //home button press programmatically
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:2.0];
        //exit app when app is in background
        NSLog(@"exit(0)");
        exit(0);
    }
}

- (IBAction)LoginiOSAction:(id)sender
{
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    [_lblStatus setText:@"  Trying to login with iOS..."];
    
    [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
    {
        self.navigationController.navigationBar.topItem.title = [username capitalizedString];
        [_lblStatus setText:@"  Logged in..."];
    } errorBlock:^(NSError *error)
    {
        [_lblStatus setText:[error localizedDescription]];
    }];
}

- (IBAction)LoginWEBAction:(id)sender
{
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"WNEGVMBUVfFRcFKhFs2hL8itV"
                                                 consumerSecret:@"tVXVy7DdZ2IKeh4T6TxpVRy2xzNnORZmAvxEfURZTodZKTCcM6"];
    
    [_lblStatus setText:@"  Trying to login with web..."];
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        [[UIApplication sharedApplication] openURL:url];
    } authenticateInsteadOfAuthorize:FALSE
                    forceLogin:@(TRUE)
                    screenName:nil
                 oauthCallback:@"myapp://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                        _lblStatus.text = [error localizedDescription];
                    }];

}

- (IBAction)TimelineAction:(id)sender
{
    if (_twitter)
    {
        [_lblStatus setText:@""];
        [_twitter getHomeTimelineSinceID:nil
                                   count:15
                            successBlock:^(NSArray *statuses) {
                                
                                NSLog(@"-- statuses: %@", statuses);
                                
                                _lblStatus.text = [NSString stringWithFormat:@"  %lu statuses loaded", (unsigned long)[statuses count]];
                                
                                self.statuses = statuses;
                                
                                [self.tableView reloadData];
                                
                            } errorBlock:^(NSError *error) {
                                _lblStatus.text = [error localizedDescription];
                            }];
    }
    else
        [_lblStatus setText:@"  PLease login"];
    
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier
{
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        
        self.navigationController.navigationBar.topItem.title = [screenName capitalizedString];
        [_lblStatus setText:@"  Logged in..."];
        
    } errorBlock:^(NSError *error) {
        _lblStatus.text = [NSString stringWithFormat:@"%@, %@",[error localizedDescription], @"PLease try again"];
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}
@end
