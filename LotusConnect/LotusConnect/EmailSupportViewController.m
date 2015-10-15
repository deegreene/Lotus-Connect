//
//  EmailSupportViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 10/15/15.
//  Copyright © 2015 Dee Greene. All rights reserved.
//

#import "EmailSupportViewController.h"

@interface EmailSupportViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation EmailSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)emailSupport:(id)sender {
    NSString *email = @"support@lotusmserv.com";
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:[NSArray arrayWithObjects:email,nil]];
    [mailComposer setSubject:[NSString stringWithFormat: @"Lotus-Connect Support"]];
    NSString *message = self.textView.text;
    NSString *supportText = [NSString stringWithFormat:@"%@", message];
    //supportText = [supportText stringByAppendingString: @"Please describe your problem or question."];
    [mailComposer setMessageBody:supportText isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self cancel:(self)];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
