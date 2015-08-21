//
//  ChartCellBar.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/11.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ChartCellBar.h"

@interface ChartCellBar ()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *districtView;

@end

@implementation ChartCellBar

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(243.0 / 255.0) green:(243.0 / 255.0) blue:(243.0 / 255.0) alpha:1];
        
        self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
        self.topLineView.backgroundColor = [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1];
        [self addSubview:self.topLineView];
        
        self.districtView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 0.5, 10, 1, CGRectGetHeight(self.frame) - 20)];
        self.districtView.backgroundColor = [UIColor colorWithRed:(204.0 / 255.0) green:(204.0 / 255.0) blue:(204.0 / 255.0) alpha:1];
        [self addSubview:self.districtView];

    }
    return self;
}

@end
