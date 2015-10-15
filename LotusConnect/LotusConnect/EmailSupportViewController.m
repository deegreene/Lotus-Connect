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
    
    if (self.textView.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Question/Concern" message:@"Opps. Looks like you didn't enter a question or concern. Let us know how we can help you so we can help you get back to work!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
    } else {
    
    NSString *email = @"support@lotusmserv.com";
    //NSString *email = @"deegreene24@yahoo.com";
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:[NSArray arrayWithObjects:email,nil]];
    [mailComposer setSubject:[NSString stringWithFormat: @"[Lotus-Connect] Lotus Management Services Support"]];
    NSString *message = self.textView.text;
    NSString *supportText = [NSString stringWithFormat:@"%@", message];
    //supportText = [supportText stringByAppendingString: @"Please describe your problem or question."];
    [mailComposer setMessageBody:supportText isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Service Ticket Submitted" message:@"Support has received your message and will be in contact as soon as possible. Your service ticket number will be emailed to you shortly." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            [alertView show];
            [self cancel:(self)];
            //NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
