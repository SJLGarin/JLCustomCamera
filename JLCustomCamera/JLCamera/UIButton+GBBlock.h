//
//  SJLViewController.m
//  CustomCamera
//
//  Created by shenjialin on 16/11/3.
//  Copyright © 2016年 shenjialin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (GBBlock)
- (void)addActionBlock:(void(^)(id sender))block forControlEvents:(UIControlEvents )event;
@end
