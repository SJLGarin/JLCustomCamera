//
//  SJLViewController.m
//  CustomCamera
//
//  Created by shenjialin on 16/11/3.
//  Copyright © 2016年 shenjialin. All rights reserved.
//

#import "UIButton+GBBlock.h"

#import <objc/runtime.h>
static const int block_key;
@interface GBtarget : NSObject
@property (nonatomic,copy)void (^block)(id sender);
@end

@implementation GBtarget

- (instancetype)initWithBlock:(void(^)(id sender))block
{
    if ([super init]) {
        self.block = [block copy];
    }
    return self;
}
- (void)buttonAction:(id)sender
{
    if (self.block) {
        self.block(sender);
    }
}

@end

@implementation UIButton (DJBlock)
- (void)addActionBlock:(void (^)(id))block forControlEvents:(UIControlEvents )event
{
    if (!block) {
        return;
    }
    [self addtargetBlock:block forControlEvents:event];
    
}
- (void)addtargetBlock:(void(^)(id))block forControlEvents:(UIControlEvents )event
{
    GBtarget *target = [[GBtarget alloc] initWithBlock:block];
    NSMutableArray *targets = [self _dj_allBlockTargets];
    [targets addObject:target];
    [self addTarget:target action:@selector(buttonAction:) forControlEvents:event];
}

- (NSMutableArray *)_dj_allBlockTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}


@end
