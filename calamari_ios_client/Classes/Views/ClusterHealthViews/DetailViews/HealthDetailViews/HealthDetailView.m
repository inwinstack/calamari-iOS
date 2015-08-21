//
//  HealthDetailView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HealthDetailView.h"
#import "UIColor+Reader.h"

@implementation HealthDetailView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.okView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - ((CGRectGetWidth(self.frame) * 0.3) / 2), CGRectGetMidY(self.frame) - ((CGRectGetWidth(self.frame) * 0.3) / 2) - 60, (CGRectGetWidth(self.frame) * 0.3), (CGRectGetWidth(self.frame) * 0.3))];
        self.okView.image = [UIImage imageNamed:@"OSDHealthOKView"];
        self.okView.contentMode = UIViewContentModeScaleAspectFill;
        self.okView.alpha = 0;
        [self addSubview:self.okView];
        
        self.okLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 100, CGRectGetMaxY(self.okView.frame) + 25, 200, 50)];
        self.okLabel.alpha = 0;
        self.okLabel.numberOfLines = 0;
        self.okLabel.textColor = [UIColor unitTextDefalutGrayColor];
        self.okLabel.textAlignment = NSTextAlignmentCenter;
        self.okLabel.text = @"Great！\nSystem works fine！";
        [self addSubview:self.okLabel];
    }
    return self;
}

@end
