//
//  CameraViewController.h
//  LotusConnect
//
//  Created by Dee Greene on 9/10/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *cameraView;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end
