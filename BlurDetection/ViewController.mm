//
//  ViewController.m
//  BlurDetection
//
//  Created by Evan Anger on 10/21/14.
//  Copyright (c) 2014 Mighty Strong Software. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIImage+OpenCV.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageTaken;

@property (weak, nonatomic) IBOutlet UILabel *blurryFactor;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)checkBlurry:(id)sender {
    cv::Mat matImage = [self.imageTaken.image toMat];
    cv::Mat matImageGrey;
    cv::cvtColor(matImage, matImageGrey, CV_BGRA2GRAY);
    
    cv::Mat dst2 =[self.imageTaken.image toMat];
    cv::Mat laplacianImage;
    dst2.convertTo(laplacianImage, CV_8UC1);
    cv::Laplacian(matImageGrey, laplacianImage, CV_8U);
    cv::Mat laplacianImage8bit;
    laplacianImage.convertTo(laplacianImage8bit, CV_8UC1);
    //-------------------------------------------------------------
    //-------------------------------------------------------------
    unsigned char *pixels = laplacianImage8bit.data;
    //-------------------------------------------------------------
    //-------------------------------------------------------------
    //    unsigned char *pixels = laplacianImage8bit.data;
    int maxLap = -16777216;
    
    for (int i = 0; i < ( laplacianImage8bit.elemSize()*laplacianImage8bit.total()); i++) {
        if (pixels[i] > maxLap)
            maxLap = pixels[i];
    }
    
    int soglia = -6118750;
    
    printf("\n maxLap : %i",maxLap);
    
    
    if (maxLap < soglia || maxLap == soglia)
        printf("\n\n***** blur image *****");
    else
        printf("\nNOT a blur image");
    
    
    self.blurryFactor.text = [NSString stringWithFormat:@"%i", maxLap];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageTaken.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
