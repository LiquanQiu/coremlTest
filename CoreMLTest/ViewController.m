//
//  ViewController.m
//  CoreMLTest
//
//  Created by LiquanQiu on 2017/10/10.
//  Copyright © 2017年 QLQ. All rights reserved.
//

#import <Photos/Photos.h>
#import "ViewController.h"
#import "UIImage+Convertor.h"
#import "GoogLeNetPlaces.h"


@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) GoogLeNetPlaces *predict;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _predict = [[GoogLeNetPlaces alloc] init];
    _resultLabel.numberOfLines = 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickBtn:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:vc animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(image){
        _image = image;
        [_imageView setImage:image];
    }
    
    NSTimeInterval startTime = clock();
    _image = [UIImage scaleImage:_image toSize:CGSizeMake(224, 224)];
    CVPixelBufferRef pix = [UIImage createPixelBufferFromCGImage:_image.CGImage];
    GoogLeNetPlacesOutput *output = [_predict predictionFromSceneImage:pix error:nil];
    CVPixelBufferRelease(pix);
    NSTimeInterval endTime = clock();
    
    NSTimeInterval predictCostTime = (endTime - startTime) * 1000 / CLOCKS_PER_SEC;
    
    NSString *resultStr = [NSString stringWithFormat:@" Label: %@\n Probs: %@\n PredictCostTime: %fms", output.sceneLabel, output.sceneLabelProbs[output.sceneLabel], predictCostTime];
    [_resultLabel setText:resultStr];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
