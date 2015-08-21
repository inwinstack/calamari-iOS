//
//  ChartView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/11.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ChartView.h"

@implementation ChartView

- (instancetype) initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
