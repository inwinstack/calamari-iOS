//
//  NotificationCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NotificationCell.h"
#import "UIView+SizeMaker.h"
#import "UIColor+Reader.h"

@implementation NotificationCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor oceanHorizonRuleTwoColor].CGColor;
        self.layer.cornerRadius = 10.0;
        self.backgroundColor = [UIColor oceanBackgroundThreeColor];
        self.statusColorView = [CAShapeLayer layer];
        self.statusColorView.frame = CGRectMake(0, 0, 10, CGRectGetHeight(self.frame));
        self.statusColorView.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 2.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 4.0) cornerRadius:9].CGPath;
        self.statusColorView.masksToBounds = YES;
        [self.layer addSublayer:self.statusColorView];
        
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusColorView.frame) + 10, 10, CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.statusColorView.frame) + 20), 0)];
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textColor = [UIColor normalBlackColor];
        self.alertContentLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self addSubview:self.alertContentLabel];
        
        self.statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.alertContentLabel.frame), CGRectGetMaxY(self.alertContentLabel.frame) + 10, 20, 20)];
        [self addSubview:self.statusImageView];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusImageView.frame) + 10, CGRectGetMinY(self.statusImageView.frame), 0, 20)];
        self.statusLabel.textColor = [UIColor normalBlackColor];
        self.statusLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
        [self addSubview:self.statusLabel];
        
        self.statusTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusLabel.frame), CGRectGetMinY(self.statusImageView.frame), 0, 20)];
        self.statusTimeLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
        self.statusTimeLabel.textColor = [UIColor unitTextDefalutGrayColor];
        [self addSubview:self.statusTimeLabel];
        
        self.archiveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - (20 + [UIView subHeadIconSize]), CGRectGetMinY(self.alertContentLabel.frame), [UIView subHeadIconSize], [UIView subHeadIconSize])];
        [self.archiveButton setBackgroundImage:[UIImage imageNamed:@"NotificationArchiveImage"] forState:UIControlStateNormal];
        [self addSubview:self.archiveButton];
    }
    return self;
}

- (void) reloadLayout {
    self.alertContentLabel.frame = CGRectMake(CGRectGetMaxX(self.statusColorView.frame) + 10, 10, CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.statusColorView.frame) + 20), 0);
    [self.alertContentLabel sizeToFit];
    self.statusImageView.frame = CGRectMake(CGRectGetMaxX(self.statusColorView.frame) + 7, CGRectGetMaxY(self.alertContentLabel.frame) + 10, 20, 15);
    self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.statusImageView.frame) + 10, CGRectGetMinY(self.statusImageView.frame), 0, 20);
    [self.statusLabel sizeToFit];
    self.statusTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.statusLabel.frame), CGRectGetMinY(self.statusImageView.frame), 0, 20);
    [self.statusTimeLabel sizeToFit];

    self.statusColorView.frame = CGRectMake(0, 0, 10, CGRectGetHeight(self.frame));
    self.statusColorView.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 2.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 4.0) cornerRadius:9].CGPath;
}

@end
