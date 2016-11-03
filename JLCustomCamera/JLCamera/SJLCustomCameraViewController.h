//
//  SJLViewController.h
//  CustomCamera
//
//  Created by shenjialin on 16/11/3.
//  Copyright © 2016年 shenjialin. All rights reserved.
//

#import <UIKit/UIKit.h>


#define JLScale ([UIScreen mainScreen].bounds.size.width/320)
#define JLWidth [UIScreen mainScreen].bounds.size.width
#define JLHeight [UIScreen mainScreen].bounds.size.height
#define JLHeightColor [UIColor colorWithRed:211/255.0 green:0 blue:85/255.0 alpha:1]
//#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


typedef void(^SendImageBlock)(UIImage *image);

@interface SJLCustomCameraViewController : UIViewController

@property (copy,nonatomic) SendImageBlock block;//传递image的block

@end
