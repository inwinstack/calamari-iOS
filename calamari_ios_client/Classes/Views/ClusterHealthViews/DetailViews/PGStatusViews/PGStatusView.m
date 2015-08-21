//
//  PGStatusView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/27.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PGStatusView.h"
#import "UIColor+Reader.h"

@implementation PGStatusView

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
    }
    return self;
}

@end
