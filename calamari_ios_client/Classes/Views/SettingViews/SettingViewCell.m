//
//  SettingViewCell.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "SettingViewCell.h"
#import "UIColor+Reader.h"

@implementation SettingViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.settingNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 30)];
        [self addSubview:self.settingNameLabel];
        
        self.selectionView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.settingNameLabel.frame), CGRectGetWidth(self.frame), 100)];
        self.selectionView.layer.cornerRadius = 5;
        self.selectionView.layer.borderWidth = 2.0;
        self.selectionView.layer.borderColor = [UIColor osdButtonHighlightColor].CGColor;
        self.selectionView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectionView.scrollEnabled = NO;
        [self addSubview:self.selectionView];
    }
    return self;
}

@end
