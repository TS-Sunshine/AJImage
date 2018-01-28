//
//  ViewController.m
//  AJImage
//
//  Created by 安静的为你歌唱 on 2018/1/24.
//  Copyright © 2018年 安静地为你歌唱. All rights reserved.
//

#import "ViewController.h"
#import "cubeMap.c"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    //size  600 × 450
    
    //显示原图片
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 160, 15)];
    oldLabel.text = @"原图";
    oldLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:oldLabel];
    
    UIImageView *oldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 80, 150, 112)];
    oldImageView.image = [UIImage imageNamed:@"hehe.png"];
    [self.view addSubview:oldImageView];
    
    //显示背景图片
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 65, 160, 15)];
    backLabel.text = @"背景图";
    backLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backLabel];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(165, 80, 150, 112)];
    backImageView.image = [UIImage imageNamed:@"111.png"];
    [self.view addSubview:backImageView];
    
    
    
    //更换背景图片
    struct CubeMap myCube = createCubeMap(6, 71);
    NSData *myData = [[NSData alloc]initWithBytesNoCopy:myCube.data length:myCube.length freeWhenDone:true];
    CIFilter *colorCubeFilter = [CIFilter filterWithName:@"CIColorCube"];
    [colorCubeFilter setValue:[NSNumber numberWithFloat:myCube.dimension] forKey:@"inputCubeDimension"];
    [colorCubeFilter setValue:myData forKey:@"inputCubeData"];
    [colorCubeFilter setValue:[CIImage imageWithCGImage:oldImageView.image.CGImage] forKey:kCIInputImageKey];
    
    CIImage *outputImage = colorCubeFilter.outputImage;
    
    CIFilter *sourceOverCompositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositingFilter setValue:outputImage forKey:kCIInputImageKey];
    [sourceOverCompositingFilter setValue:[CIImage imageWithCGImage:backImageView.image.CGImage] forKey:kCIInputBackgroundImageKey];
    
    outputImage = sourceOverCompositingFilter.outputImage;
    struct CGImage *cgImage = [[CIContext contextWithOptions:nil]createCGImage:outputImage fromRect:outputImage.extent];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 15)];
    newLabel.text = @"合成图";
    newLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:newLabel];
    
    
    UIImageView *newImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 220, 300, 225)];
    newImageView.image = [UIImage imageWithCGImage:cgImage];
    [self.view addSubview:newImageView];
    
    
    
    [self CutImageWithImage:backImageView.image withRect:CGRectMake(0, 300, 300 , 300)];
    
}
//剪切的方法
- (UIImage *)CutImageWithImage:(UIImage *)image withRect:(CGRect)rect
{
    //使用CGImageCreateWithImageInRect方法切割图片，第一个参数为CGImage类型，第二个参数为要切割的CGRect
    CGImageRef cutImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    //将切割出得图片转换为UIImage
    UIImage *resultImage = [UIImage imageWithCGImage:cutImage];
    return resultImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
