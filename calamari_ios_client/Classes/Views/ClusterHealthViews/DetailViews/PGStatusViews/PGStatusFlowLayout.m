//
//  PGStatusFlowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/27.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PGStatusFlowLayout.h"

@implementation PGStatusFlowLayout

- (instancetype) init {
    self = [super init];
    if (self) {
//        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, 60);
        self.minimumLineSpacing = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05;
        self.sectionInset = UIEdgeInsetsMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, 0, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, 0);
    }
    return self;
}

@end
