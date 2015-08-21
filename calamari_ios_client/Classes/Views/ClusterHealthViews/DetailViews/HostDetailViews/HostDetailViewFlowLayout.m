//
//  HostDetailViewFlowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostDetailViewFlowLayout.h"

@implementation HostDetailViewFlowLayout

- (instancetype) init {
    self = [super init];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.headerReferenceSize = CGSizeMake(0, 0);
        self.footerReferenceSize = CGSizeMake(0, 50);
        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.9, height * 270 / 255);
        self.minimumLineSpacing = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05;
    }
    return self;
}

@end
