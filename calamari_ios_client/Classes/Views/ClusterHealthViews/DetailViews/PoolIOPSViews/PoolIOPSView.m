//
//  PoolIOPSView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PoolIOPSView.h"
#import "UIColor+Reader.h"

@implementation PoolIOPSView

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
    }
    return self;
}

@end
