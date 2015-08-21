//
//  ChartFlowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/11.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ChartFlowLayout.h"

@implementation ChartFlowLayout

- (void) prepareLayout {
    [super prepareLayout];
    self.sectionInset = UIEdgeInsetsMake(5, 10, -5, 10);
    self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20, (CGRectGetWidth([UIScreen mainScreen].bounds) - 20) * 1.15);
}

@end
