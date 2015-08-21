//
//  NavigationViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/8/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NavigationViewCell.h"
#import "UIView+SizeMaker.h"
#import "UIColor+Reader.h"

@implementation NavigationViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIView tbMarginOne], 10.8, CGRectGetWidth(self.frame) - [UIView tbMarginOne] * 2, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.nameLabel.textColor = [UIColor colorWithRed:5.0 / 255.0 green:5.0 / 255.0 blue:5.0 / 255.0 alpha:1];
        [self addSubview:self.nameLabel];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
    }
    return self;
}

@end
