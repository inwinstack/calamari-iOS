//
//  HostHealthView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostHealthView.h"
#import "UIColor+Reader.h"

@implementation HostHealthView

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
    }
    return self;
}

@end
