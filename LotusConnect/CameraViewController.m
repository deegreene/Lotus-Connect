//
//  CameraViewController.m
//  LotusConnect
//
//  Created by Dee Greene on 9/10/15.
//  Copyright (c) 2015 Dee Greene. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize cameraView, captureSession, stillImageOutput, previewLayer;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    previewLayer.frame = cameraView.bounds;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    captureSession = [[AVCaptureSession alloc] init];
    captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    
    AVCaptureDevice *backCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:backCamera error:&error];
    
    if (error == nil && [captureSession canAddInput:input]) {
        [captureSession addInput:input];
        
        stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
        
        if ([captureSession canAddOutput:stillImageOutput]) {
            [captureSession addOutput:stillImageOutput];
            
            previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            [cameraView.layer insertSublayer:previewLayer atIndex:0];
            [captureSession startRunning];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
