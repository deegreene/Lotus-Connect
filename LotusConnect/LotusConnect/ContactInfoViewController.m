//
//  ContactInfoViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "ContactInfoViewController.h"

@interface ContactInfoViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFUser *contact = self.currentContact;
    
    self.contactFullName.text = [NSString stringWithFormat:@"%@ %@",[contact objectForKey:@"firstName"],[contact objectForKey:@"lastName"]];
    self.contactCompanyName.text = [contact objectForKey:@"companyName"];
    
    //set profile image
    if ([contact objectForKey:@"profileImage"] == nil) {
        self.profileImage.image = [UIImage imageNamed:@"friends"];
    }else {
        // download image from Parse.com
        PFFile *imageFile = [contact objectForKey:@"profileImage"];
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        self.profileImage.image = [UIImage imageWithData:imageData];
    }
    
    // round buttons
    self.emailButton.layer.cornerRadius = CGRectGetWidth(self.emailButton.frame) / 2.0f;
    self.callButton.layer.cornerRadius = CGRectGetWidth(self.callButton.frame) / 2.0f;
    self.faceTimeButton.layer.cornerRadius = CGRectGetWidth(self.faceTimeButton.frame) / 2.0f;

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

- (IBAction)callContact:(id)sender {
    PFUser *contact = self.currentContact;
    NSString *phone = [NSString stringWithFormat:@"tel:%@",[contact objectForKey:@"Phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
}

- (IBAction)facetimeContact:(id)sender {
    PFUser *contact = self.currentContact;
    NSString *facetime = [NSString stringWithFormat:@"facetime:%@",[contact objectForKey:@"Phone"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facetime]];
}

- (IBAction)emailContact:(id)sender {
    PFUser *contact = self.currentContact;
    NSString *email = [contact objectForKey:@"email"];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    [mailComposer setToRecipients:[NSArray arrayWithObjects:email,nil]];
    [mailComposer setSubject:[NSString stringWithFormat: @""]];
    NSString *supportText = [NSString stringWithFormat:@""];
    //supportText = [supportText stringByAppendingString: @"Please describe your problem or question."];
    [mailComposer setMessageBody:supportText isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
