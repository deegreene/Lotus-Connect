//
//  LoginCompanyTableViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/12/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignupCompanyTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *companies;
@property (nonatomic, strong) PFObject *selectedCompany;

@property (nonatomic, strong) NSMutableDictionary *companiesDictionary;
@property (nonatomic, strong) NSMutableArray *companySectionTitles;
@property (nonatomic, strong) NSArray *companyIndexTitles;

@end
