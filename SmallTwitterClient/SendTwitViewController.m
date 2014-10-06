//
//  SendTwitViewController.m
//  SmallTwitterClient
//
//  Created by Gorf on 10/4/14.
//  Copyright (c) 2014 Gorf. All rights reserved.
//

#import "SendTwitViewController.h"

@interface SendTwitViewController ()
@end

@implementation SendTwitViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGFloat height = self.navigationController.navigationBar.frame.size.height +
    (statusBarFrame.size.height > statusBarFrame.size.width ? statusBarFrame.size.width : statusBarFrame.size.height);
    [_cnstrTop setConstant:height];
    [self.view layoutIfNeeded];
    
    [_txtText setDelegate:self];
    [_lblCount setText:@"  140 characters left"];
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 140)
        [textView setText:[textView.text substringToIndex:140]];
    [_lblCount setText:[NSString stringWithFormat:@"  %d characters left", (int)(140 - textView.text.length)]];
}

- (IBAction)TweetAction:(id)sender
{
    if (_twitter)
    {
        [_twitter postStatusUpdate:_txtText.text inReplyToStatusID:NULL latitude:NULL longitude:NULL placeID:NULL displayCoordinates:NULL trimUser:NULL successBlock:^(NSDictionary *status) {
            NSLog(@"status - %@",status);
            [_lblStatus setText:@"  Tweet sent"];
        } errorBlock:^(NSError *error) {
            NSLog(@"error - %@",error);
            [_lblStatus setText:[error localizedDescription]];
        }];
        [_txtText setText:@""];
        [_lblCount setText:@"  140 characters left"];        
    }
    else
        [_lblStatus setText:[NSString stringWithFormat:@"  Not logged in!"]];

}
- (IBAction)TouchInterceptAction:(id)sender
{
    [_txtText endEditing:TRUE];
}
@end
