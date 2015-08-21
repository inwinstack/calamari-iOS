//
//  PoolIOPSViewFlowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PoolIOPSViewFlowLayout.h"

@implementation PoolIOPSViewFlowLayout

- (instancetype) init {
    self = [super init];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;

        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, height * 250 / 255);
        self.sectionInset = UIEdgeInsetsMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, 0);
        self.minimumLineSpacing = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05;
    }
    return self;
}

@end
