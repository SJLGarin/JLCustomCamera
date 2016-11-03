//
//  SJLViewController.m
//  CustomCamera
//
//  Created by shenjialin on 16/11/3.
//  Copyright © 2016年 shenjialin. All rights reserved.
//

#import "SJLCustomCameraViewController.h"
#import "UIButton+GBBlock.h"
#import <AVFoundation/AVFoundation.h>


#define JLWScale ([UIScreen mainScreen].bounds.size.width/320)
#define JLHScale ([UIScreen mainScreen].bounds.size.height/640)
#define JLWidth [UIScreen mainScreen].bounds.size.width
#define JLHeight [UIScreen mainScreen].bounds.size.height
#define JLHeightColor [UIColor colorWithRed:211/255.0 green:0 blue:85/255.0 alpha:1]
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define PictureWidth 216*JLWScale
#define PictureHeight 342.4*JLWScale


@interface SJLCustomCameraViewController ()
{
    UIView *_viewContainer;
}

@property (strong,nonatomic) UIView *pictureView; //可以换成图片，或者用自己画
@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//iOS10之前的照片输出流
//@property (strong,nonatomic) AVCapturePhotoOutput *capturePhotoOutput;//iOS10之后的照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@end

@implementation SJLCustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    [self setupCameraView];
    [self setupTakePhotoBtn];
    [self setupCancleBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
//    if(SystemVersion<10.0){
        //初始化设备输出对象，用于获得输出数据
        _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
        NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
        [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
//    }else{
//        _capturePhotoOutput=[[AVCapturePhotoOutput alloc]init];
//        _capturePhotoOutput.
//    }
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
//    if(SystemVersion<10.0){
        //将设备输出添加到会话中
        if ([_captureSession canAddOutput:_captureStillImageOutput]) {
            [_captureSession addOutput:_captureStillImageOutput];
        }
//    }else{
//        
//    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    
    CALayer *layer=_viewContainer.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame=layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_captureSession stopRunning];
}

// 取得指定位置的摄像头
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}



//定义相机现实的界面及设置相关滤镜等属性
- (void)setupCameraView
{
    _viewContainer=[[UIView alloc]initWithFrame:CGRectMake(0, 44,JLWidth, JLWidth + 145 * JLWScale - 44)];
    [self.view addSubview:_viewContainer];
    
    _pictureView=[[UIView alloc]initWithFrame:CGRectMake((JLWidth-PictureWidth)/2.0, (JLWidth + 145 * JLWScale - 44-PictureHeight)/2.0+44, PictureWidth, PictureHeight)];
    _pictureView.layer.borderWidth=2.0;
    _pictureView.layer.borderColor=[UIColor yellowColor].CGColor;
    _pictureView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_pictureView];
}


//定义拍照按钮
- (void)setupTakePhotoBtn
{
    UIButton *takePhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake((JLWidth - 60 * JLWScale) / 2, JLWidth + 145 * JLWScale +(JLHeight - JLWidth - 205 * JLWScale) / 2, 60 * JLWScale, 60 * JLWScale)];
    [takePhotoBtn setImage:[UIImage imageNamed:@"btn_camera_all"] forState:UIControlStateNormal];
    [takePhotoBtn setImage:[UIImage imageNamed:@"btn_camera_all_click"] forState:UIControlStateHighlighted];
    [self.view addSubview:takePhotoBtn];
    
    WS(weakSelf)
    
    [takePhotoBtn addActionBlock:^(id sender) {
        
        UIButton *btn = (UIButton *)sender;
        btn.enabled = NO;
        //根据设备输出获得连接
        AVCaptureConnection *captureConnection=[weakSelf.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        //根据连接取得设备输出的数据
        [weakSelf.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            btn.enabled = YES;
            if (imageDataSampleBuffer) {
                NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                CGRect frame=weakSelf.pictureView.frame;
                CGRect rect=CGRectMake((frame.origin.y+20)*2/JLHScale, frame.origin.x*2/JLWScale, frame.size.height*2, frame.size.width*2);
                UIImage *oldImage=[UIImage imageWithData:imageData];
                CGImageRef imageRef =oldImage.CGImage;
                CGImageRef image = CGImageCreateWithImageInRect(imageRef,rect);
                UIImage *newImage = [[UIImage alloc] initWithCGImage:image];
                weakSelf.block(newImage);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
}


//取消按钮
- (void)setupCancleBtn
{
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 * JLWScale, JLWidth + 180 * JLWScale, 40 * JLWScale, 30 * JLWScale)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn setTitleColor:JLHeightColor forState:UIControlStateHighlighted];
    [self.view addSubview:cancleBtn];
    WS(weakSelf)
    [cancleBtn addActionBlock:^(id sender) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
