//
//  ChartCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/11.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ChartCell.h"
#import "UIColor+Reader.h"

@implementation ChartCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        
        self.bottomBar = [[ChartCellBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 80, CGRectGetWidth(self.frame), 80)];
        [self addSubview:self.bottomBar];
        
    }
    return self;
}

@end
