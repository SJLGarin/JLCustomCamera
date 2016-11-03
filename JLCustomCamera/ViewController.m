//
//  ViewController.m
//  JLCustomCamera
//
//  Created by shenjialin on 16/11/3.
//  Copyright © 2016年 shenjialin. All rights reserved.
//

#import "ViewController.h"
#import "SJLCustomCameraViewController.h"
@interface ViewController ()
@property (copy,nonatomic) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 30)];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"测试" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 300)];
    _imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
}

- (void)btnClick:(UIButton *)btn{
    //    JLCustomCameraViewController *vc=[JLCustomCameraViewController new];
    SJLCustomCameraViewController *vc=[SJLCustomCameraViewController new];
    WS(ws);
    vc.block=^(UIImage *image){
        ws.imageView.image=image;
    };
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
