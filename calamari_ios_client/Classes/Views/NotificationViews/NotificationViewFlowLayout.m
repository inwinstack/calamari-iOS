//
//  NotificationViewFlowLayout.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/1.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NotificationViewFlowLayout.h"
#import "UIView+SizeMaker.h"

@implementation NotificationViewFlowLayout

- (instancetype) init {
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 65);
        self.minimumLineSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    }
    return self;
}

@end
