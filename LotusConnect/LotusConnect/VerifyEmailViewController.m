//
//  VerifyEmailViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "VerifyEmailViewController.h"

@interface VerifyEmailViewController ()

@end

@implementation VerifyEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.verifyEmailLabel.text = [NSString stringWithFormat:@"Email sent to %@. Verify to continue", self.email];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkVerification:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    [user fetch];
    if ([user objectForKey:@"emailVerified"] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Click the link in your email to continue" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
}
@end
