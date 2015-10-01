//
//  LoginCompanyTableViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/12/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "SignupCompanyTableViewController.h"
#import "CompanyKeyViewController.h"

@interface SignupCompanyTableViewController ()

@end

@implementation SignupCompanyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    // query all the company names
    PFQuery *query = [PFQuery queryWithClassName:@"Companies"];
    [query orderByAscending:@"companyName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            self.companies = objects;
            //NSLog(@"company names: %@", self.companies);
            
            //alphabetical scroll code
            self.companiesDictionary = [[NSMutableDictionary alloc] init];
            
            BOOL found;
            
            // Loop through the books and create our keys
            for (NSDictionary *company in self.companies)
            {
                NSString *c = [[company objectForKey:@"companyName"] substringToIndex:1];
                
                found = NO;
                
                for (NSString *str in [self.companiesDictionary allKeys])
                {
                    if ([str isEqualToString:c])
                    {
                        found = YES;
                    }
                }
                
                if (!found)
                {
                    //NSLog(@"letter: %@", c);
                    [self.companiesDictionary setValue:[[NSMutableArray alloc] init] forKey:c];
                }
            }
            
            // Loop again and sort the companies into their respective keys
            for (NSDictionary *company in self.companies)
            {
                //NSLog(@"%@", company);
                [[self.companiesDictionary objectForKey:[[company objectForKey:@"companyName"] substringToIndex:1]] addObject:company];
            }
            
            /*
            // Sort each section array
            for (NSString *key in [self.companiesDictionary allKeys])
            {
                [[self.companiesDictionary objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
            }
            */
            
            //NSLog(@"here: %@", self.companiesDictionary);
            //NSLog(@"%@", [self.companiesDictionary allKeys]);
            
            //end alphabetical scroll code
            
            
            [self.tableView reloadData];
        }
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.companiesDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    //return self.companies.count;
    return [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

/* uncomment for scrolling letters on the side...code is currently WRONG!
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //return [[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return self.companyIndexTitles;
}
*/

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    /*
    NSLog(@"%@ is at position %lu", title,(unsigned long)[self.companySectionTitles indexOfObject:title]);
    return [self.companySectionTitles indexOfObject:title];
    */
    
    //NSLog(@"%@", [self.companiesDictionary allKeys]);
    //NSLog(@"%@ is at position %lu",title, (unsigned long)[[self.companiesDictionary allKeys] indexOfObject:title]);
    return [[self.companiesDictionary allKeys] indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    /*
    PFObject *company = [self.companies objectAtIndex:indexPath.row];
    
    NSString *companyName = [company objectForKey:@"companyName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", companyName];
    */
    
    //NEW CODE
    NSDictionary *company = [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [company objectForKey:@"companyName"];
    
    return cell;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = @"Select Company";
    
    return sectionName;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //self.selectedCompany = [self.companies objectAtIndex:indexPath.row];
    self.selectedCompany = [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showCompanyKey" sender:self];
    
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCompanyKey"]) {
        CompanyKeyViewController *vc = (CompanyKeyViewController *)segue.destinationViewController;
        //[vc setHidesBottomBarWhenPushed:YES];
        vc.company = self.selectedCompany;
    }
    
}

@end
