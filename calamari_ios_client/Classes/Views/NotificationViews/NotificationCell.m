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

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, [UIView iconBodySize], [UIView iconBodySize])];
        [self addSubview:self.statusImage];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusImage.frame) + 5, CGRectGetMinY(self.statusImage.frame), CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.statusImage.frame) + 10) - 50, CGRectGetHeight(self.frame) / 2)];
        self.titleLabel.textColor = [UIColor normalBlackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusImage.frame) + 5, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.statusImage.frame) + 10) - [UIView subHeadIconSize], CGRectGetHeight(self.frame) / 2)];
        self.contentLabel.textColor = [UIColor unitTextDefalutGrayColor];
        self.contentLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
        [self addSubview:self.contentLabel];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 15, CGRectGetMaxY(self.titleLabel.frame) - [UIView subHeadIconSize], [UIView subHeadIconSize], [UIView subHeadIconSize])];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"CancelImage"] forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
    }
    return self;
}

@end
