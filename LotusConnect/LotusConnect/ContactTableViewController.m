//
//  CompaniesTableViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/8/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "ContactTableViewController.h"
#import "ContactInfoViewController.h"
#import "ContactInfoTableViewController.h"
#import "GravatarUrlBuilder.h"

#import <Parse/Parse.h>

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.companyIndexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(refreshContacts)
                  forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getAllContacts];
    
    [self.tableView reloadData];
    
}

- (void)getAllContacts {
    
    //PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    //query for users within same company as well as lotus employees
    if ([[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) {
        // user IS able to see ALL contacts
        PFQuery *query = [PFUser query];
        [query orderByAscending:@"companyName"];
        [query orderByAscending:@"firstName"];
        [query whereKey:@"objectId" notEqualTo:[[PFUser currentUser] objectId]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                self.contacts = objects;
                //NSLog(@"contact names: %@", self.contacts);
                
                //alphabetical scroll code
                self.companiesDictionary = [[NSMutableDictionary alloc] init];
                
                BOOL found;
                
                // Loop through the books and create our keys
                for (NSDictionary *contact in self.contacts)
                {
                    NSString *c = [[contact objectForKey:@"companyName"] substringToIndex:1];
                    
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
                        [self.companiesDictionary setValue:[[NSMutableArray alloc] init] forKey:c];
                    }
                }
                
                // Loop again and sort the companies into their respective keys
                for (NSDictionary *contact in self.contacts)
                {
                    [[self.companiesDictionary objectForKey:[[contact objectForKey:@"companyName"] substringToIndex:1]] addObject:contact];
                }
                
                /*
                 // Sort each section array
                 for (NSString *key in [self.companiesDictionary allKeys])
                 {
                 [[self.companiesDictionary objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
                 }
                 */
                
                //NSLog(@"here: %@", self.companiesDictionary);
                
                //end alphabetical scroll code
                
                
                [self.tableView reloadData];
            }
        }];
    } else {
        // user can only see LOTUS EMPLOYEES
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"companyName = 'Lotus Management Services'"];
        PFQuery *query = [PFUser queryWithPredicate:predicate];
        [query orderByAscending:@"companyName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                self.contacts = objects;
                //NSLog(@"contact names: %@", self.contacts);
                
                //alphabetical scroll code
                self.companiesDictionary = [[NSMutableDictionary alloc] init];
                
                BOOL found;
                
                // Loop through the books and create our keys
                for (NSDictionary *contact in self.contacts)
                {
                    NSString *c = [[contact objectForKey:@"companyName"] substringToIndex:1];
                    
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
                        [self.companiesDictionary setValue:[[NSMutableArray alloc] init] forKey:c];
                    }
                }
                
                // Loop again and sort the companies into their respective keys
                for (NSDictionary *contact in self.contacts)
                {
                    [[self.companiesDictionary objectForKey:[[contact objectForKey:@"companyName"] substringToIndex:1]] addObject:contact];
                }
                
                /*
                 // Sort each section array
                 for (NSString *key in [self.companiesDictionary allKeys])
                 {
                 [[self.companiesDictionary objectForKey:key] sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyName" ascending:YES]]];
                 }
                 */
                
                //NSLog(@"here: %@", self.companiesDictionary);
                
                //end alphabetical scroll code
                
                
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)refreshContacts {
    
    //get new contacts
    [self getAllContacts];
    
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        /*
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        */
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.companiesDictionary allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
        //return self.contacts.count;
    return [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) {
        // user is a lotus employee and can see all contacts
        return [[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    } else {
        // user is a client and can only see lotus employees
        return @"Support";
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //return [[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
   
    if ([[[PFUser currentUser] objectForKey:@"allContactsRights"] boolValue]) {
        // alphabetical scrolling enabled for lotus employees
        return self.companyIndexTitles;
    } else {
        // alphabetical scrolling disabled for clients
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //NSLog(@"%@ is at position %lu",title, (unsigned long)[[self.companiesDictionary allKeys] indexOfObject:title]);
    return [[self.companiesDictionary allKeys] indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    /*
    PFUser *user = [self.contacts objectAtIndex:indexPath.row];
    
    NSString *firstName = [user objectForKey:@"firstName"];
    NSString *lastName = [user objectForKey:@"lastName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.detailTextLabel.text = [user objectForKey:@"companyName"];
    */
    
    //NEW CODE
    NSDictionary *contact = [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    NSString *firstName = [contact objectForKey:@"firstName"];
    NSString *lastName = [contact objectForKey:@"lastName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    cell.detailTextLabel.text = [contact objectForKey:@"companyName"];
    
    /*
    //set profile image
    if ([contact objectForKey:@"profileImage"] == nil) {
        //cell.imageView.image = [UIImage imageNamed:@"friends"];
    }else {
        // download image from Parse.com
        PFFile *imageFile = [contact objectForKey:@"profileImage"];
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        cell.imageView.image = [UIImage imageWithData:imageData];
    }
    */
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //self.selectedCompany = [self.companies objectAtIndex:indexPath.row];
    self.selectedContact = [[self.companiesDictionary valueForKey:[[[self.companiesDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showContactInfo" sender:self];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //PFUser *user = [self.contacts objectAtIndex:indexPath.row];
    
    if ([segue.identifier isEqualToString:@"showContactInfo"]) {
      [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ContactInfoViewController *vc = segue.destinationViewController;
        vc.currentContact = self.selectedContact;
    }
}

#pragma mark - Search

@end
