//
//  CompanyKeyViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/12/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "CompanyKeyViewController.h"
#import "SignupViewController.h"

@interface CompanyKeyViewController ()

@end

@implementation CompanyKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyName = [self.company objectForKey:@"companyName"];
    self.companyNameLabel.text = self.companyName;
    //self.navigationItem.title = self.companyName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showSignup"]) {
        SignupViewController *vc = (SignupViewController *)segue.destinationViewController;
        
        vc.companyName = self.companyName;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSString *companyPassword = [self.company objectForKey:@"companyPassword"];
    
    if ([self.companyKeyTextField.text isEqual:companyPassword]) {
        // go to next page
        return YES;
    } else {
        // company keys dont match!
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid company password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        self.companyKeyTextField.text = nil; // clear text field
        
        return NO;
        
    }
    
    //return YES;
}

- (IBAction)next:(id)sender {
    /*
    NSString *companyKey = [self.company objectForKey:@"companyPassword"];
    NSLog(@"%@", companyKey);
    if ([self.companyKeyTextField.text isEqual:companyKey]) {
        // go to next page
    } else {
        // company keys dont match!
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occured" message:@"company keys do not match!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }
     */
}

@end
