//
//  HostHealthFlowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostHealthFlowLayout.h"

@implementation HostHealthFlowLayout

- (instancetype) init {
    self = [super init];
    if (self) {
//        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, 60);
        self.sectionInset = UIEdgeInsetsMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, 0, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, 0);
        self.minimumLineSpacing = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05;
    }
    return self;
}

@end
