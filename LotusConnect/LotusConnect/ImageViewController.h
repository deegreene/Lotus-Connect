//
//  ImageViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/9/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
