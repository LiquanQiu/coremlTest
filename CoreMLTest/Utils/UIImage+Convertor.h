//
//  UIImage+Convertor.h
//  CoreMLTest
//
//  Created by LiquanQiu on 2017/10/15.
//  Copyright © 2017年 QLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Convertor)

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

// note that you need to call CVPixelBufferRelease() to release the pixBuf
+ (CVPixelBufferRef)createPixelBufferFromCGImage:(CGImageRef)image;
@end
