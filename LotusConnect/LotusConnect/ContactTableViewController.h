//
//  CompaniesTableViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ContactTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong) PFUser *selectedContact;
@property (nonatomic, strong) NSArray *searchResults;

// for alphabetical scrolling
@property (nonatomic, strong) NSMutableDictionary *companiesDictionary;
@property (nonatomic, strong) NSMutableArray *companySectionTitles;
@property (nonatomic, strong) NSArray *companyIndexTitles;

@end
