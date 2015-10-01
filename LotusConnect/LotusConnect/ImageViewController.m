//
//  ImageViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/9/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *senderName = [self.message objectForKey:@"senderFullName"];
    self.navigationItem.title = senderName;
    
    // download image from Parse.com
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    
    //set the image view to the message image
    self.imageView.image = [UIImage imageWithData:imageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)imageWasPressed:(id)sender {
    
    if (self.navigationController.navigationBar.hidden == YES) {
        [self.navigationController setNavigationBarHidden: NO animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } else {
        [self.navigationController setNavigationBarHidden: YES animated:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
}

@end
