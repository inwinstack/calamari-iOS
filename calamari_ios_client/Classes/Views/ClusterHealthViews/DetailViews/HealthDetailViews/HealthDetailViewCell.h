//
//  HealthDetailViewCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDetailViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *statusImage;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *lineView;

- (void) reloadLayout;

@end
