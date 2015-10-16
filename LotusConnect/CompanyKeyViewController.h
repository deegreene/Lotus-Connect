//
//  CompanyKeyViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/12/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface CompanyKeyViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) PFObject *company;
@property (weak, nonatomic) IBOutlet UITextField *companyKeyTextField;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (nonatomic, strong) NSString *companyName;


- (IBAction)next:(id)sender;

@end
