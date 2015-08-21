//
//  PoolListView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PoolListView.h"
#import "UIColor+Reader.h"

@implementation PoolListView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end
