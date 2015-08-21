//
//  MONHealthFlowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "MONHealthFlowLayout.h"

@implementation MONHealthFlowLayout

- (instancetype) init {
    self = [super init];
    if (self) {

        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 10, 65);
        
        self.sectionInset = UIEdgeInsetsMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 10) * 0.0125, 10, 0, 0);
    }
    return self;
}

@end
