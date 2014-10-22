//
//  UIImage+OpenCV.h
//  BlurDetection
//
//  Created by Evan Anger on 10/21/14.
//  Copyright (c) 2014 Mighty Strong Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface UIImage (OpenCV)
- (cv::Mat)toMat;
+ (UIImage *)imageFromCVMat:(cv::Mat)mat;
@end
