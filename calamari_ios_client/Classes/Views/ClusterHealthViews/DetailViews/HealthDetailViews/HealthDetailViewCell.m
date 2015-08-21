//
//  HealthDetailViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HealthDetailViewCell.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface HealthDetailViewCell ()

@end

@implementation HealthDetailViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        
        self.statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(height * 5 / 255, height * 5 / 255, [UIView iconBodySize], [UIView iconBodySize])];
        [self addSubview:self.statusImage];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.statusImage.frame) + height * 5 / 255, CGRectGetMinY(self.statusImage.frame), CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.statusImage.frame) + height * 10 / 255), CGRectGetHeight(self.statusImage.frame))];
        self.statusLabel.numberOfLines = 0;
        self.statusLabel.textColor = [UIColor normalBlackColor];
        self.statusLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self addSubview:self.statusLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.statusImage.frame), CGRectGetMaxY(self.frame) - 1, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMinX(self.statusImage.frame) * 2, 1)];
        self.lineView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void) reloadLayout {
    float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    self.statusImage.frame = CGRectMake(height * 5 / 255, CGRectGetHeight(self.frame) / 2 - [UIView iconBodySize] / 2, [UIView iconBodySize], [UIView iconBodySize]);
    self.statusLabel.frame = CGRectMake(CGRectGetMaxX(self.statusImage.frame) + 5, height * 5 / 255, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetMaxX(self.statusImage.frame) - 20, 0);
    [self.statusLabel sizeToFit];
    self.lineView.frame = CGRectMake(CGRectGetMinX(self.statusImage.frame), CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - (CGRectGetMinX(self.statusImage.frame) * 2), 1);
}

@end
