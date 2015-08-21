//
//  OSDViewFLowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/19.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDViewFLowLayout.h"

@implementation OSDViewFLowLayout

- (instancetype) init {
    self = [super init];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.1875, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.1875);
        self.minimumInteritemSpacing = height * 5 / 255;
        self.minimumLineSpacing = height * 15 / 255;
        self.headerReferenceSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - height * 10 / 255, height * 50 / 255);
        self.sectionInset = UIEdgeInsetsMake( (CGRectGetWidth([UIScreen mainScreen].bounds) - 15) / 8, height * 10 / 255, (CGRectGetWidth([UIScreen mainScreen].bounds) - 15) / 8, height * 10 / 255);
    }
    return self;
}

@end
