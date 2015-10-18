//
//  EditInfoViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 10/16/15.
//  Copyright © 2015 Dee Greene. All rights reserved.
//

#import "EditInfoViewController.h"

@interface EditInfoViewController ()

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    self.phoneNumberField.delegate = self;
    
    self.firstNameField.text = [self.currentUser objectForKey:@"firstName"];
    self.lastNameField.text = [self.currentUser objectForKey:@"lastName"];
    self.emailField.text = [self.currentUser objectForKey:@"email"];
    self.phoneNumberField.text = [self.currentUser objectForKey:@"Phone"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextField delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - save/cancel methods

- (IBAction)saveInfo:(id)sender {
    //go back and verify each field
    //right takes off white spaces and new lines
    
    NSString *firstName = [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *phoneNumber = [self.phoneNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
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
        
    } else { // all fields are valid,
        
        [self.currentUser setObject:firstName forKey:@"firstName"];
        [self.currentUser setObject:lastName forKey:@"lastName"];
        [self.currentUser setObject:email forKey:@"email"];
        [self.currentUser setObject:email forKey:@"username"];
        [self.currentUser setObject:phoneNumber forKey:@"Phone"];
        [self.currentUser save];
        /*
        // save changes
        PFQuery *query = [PFUser query];
        
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:[self.currentUser objectId]
                                     block:^(PFObject *user, NSError *error) {
                                         // Now let's update it with some new data. In this case, only cheatMode and score
                                         // will get sent to the cloud. playerName hasn't changed.
                                         NSLog(@"user: %@", user);
                                         user[@"firstName"] = firstName;
                                         user[@"lastName"] = lastName;
                                         user[@"email"] = email;
                                         user[@"Phone"] = phoneNumber;
                                         [user saveInBackground];
                                     }];
         */
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
