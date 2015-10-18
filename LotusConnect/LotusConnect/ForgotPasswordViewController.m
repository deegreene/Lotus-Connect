//
//  ForgotPasswordViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 10/17/15.
//  Copyright © 2015 Dee Greene. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)resetPassword:(id)sender {
    
    NSString *email = self.emailTextField.text;
    
    if (email == nil) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password Reset Failed" message:@"Please enter your emaill address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        self.emailTextField.text = nil;
    } else {
        
        [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
            if(!error) {
                NSLog(@"Email sent");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password Reset"message:[NSString stringWithFormat:@"An email with reset instructions has been sent to %@", email] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                [self cancel:self];
            } else {
                //NSLog(@"%@", [error description]);
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password Reset Failed" message:@"Invalid emaill address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                self.emailTextField.text = nil;
            }
        }];
        
    }
}

- (IBAction)cancel:(id)sender {
    self.emailTextField.text = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
