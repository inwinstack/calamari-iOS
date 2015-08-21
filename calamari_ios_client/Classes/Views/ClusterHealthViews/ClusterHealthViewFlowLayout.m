//
//  ClusterHealthViewFlowLayout.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/13.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ClusterHealthViewFlowLayout.h"

@interface  ClusterHealthViewFlowLayout()
@end

@implementation ClusterHealthViewFlowLayout

- (void) prepareLayout {
    [super prepareLayout];
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        self.minimumInteritemSpacing = 20;
        self.minimumLineSpacing = 20;
        self.itemSize = CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) / 2, ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2);
    } else {
        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16 , (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85);
    }
    
}

@end

