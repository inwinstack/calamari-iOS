//
//  ClusterHealthView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ClusterHealthView.h"
#import "UIColor+Reader.h"

@implementation ClusterHealthView

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
    }
    return self;
}

@end
