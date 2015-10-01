//
//  SignupViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "SignupViewController.h"
#import "VerifyEmailViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    self.phoneNumberField.delegate = self;
    self.passwordField.delegate = self;
    self.confirmPasswordField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)signUp:(id)sender {
    //go back and verify each field
    //right takes off white spaces and new lines
    
    NSString *firstName = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *phoneNumber = [self.phoneNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *companyName = [self.companyName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *confirmPassword = [self.confirmPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // make sure all fields are filled out
    
    if ( [firstName length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing first name" message:@"Please enter your first name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    
    }else if ( [lastName length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing last name" message:@"Please enter your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    
    } else if ( [phoneNumber length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing phone number" message:@"Please enter your phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    
    } else if ( [email length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing email" message:@"Please enter your email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    
    } else if ( [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing password" message:@"Please enter a password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    
    } else if ( [confirmPassword length] == 0 || ![password isEqualToString:confirmPassword]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mismatching Passwords" message:@"Both password fields must match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        // clear password fields
        self.confirmPasswordField.text = nil;
    
    } else { // all fields are valid,
        
        PFUser *newUser = [PFUser user]; // create new user
        newUser.username = email;
        newUser[@"firstName"] = firstName;
        newUser[@"lastName"] = lastName;
        newUser[@"Phone"] = phoneNumber;
        newUser[@"companyName"] = companyName;
        newUser.email = email;
        newUser.password = password;
        
        //save the user to Parse.com
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                // clear fields if an error occurs
                self.passwordField.text = nil;
                self.confirmPasswordField.text = nil;
            } else {
                //[self performSegueWithIdentifier:@"showVerifyEmail" sender:self]; // when verify email works
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
        // more sequential code that runs right away
    }
    
    
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // auto-fill company names
    if ([currentString isEqualToString:@"Lotus"]) {
        self.companyNameField.text = @"Lotus Management Services";
        return NO;
    }
    return YES;
}
*/

/* uncomment to segue to verify email screen
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVerifyEmail"]) {
        VerifyEmailViewController *vc = segue.destinationViewController;
        vc.email = self.emailField.text;
        [vc setHidesBottomBarWhenPushed:YES];
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES]; //hide bottom tab bar
    }
}
*/

#pragma mark - UITextField delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
