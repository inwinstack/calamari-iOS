//
//  NotificationCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (nonatomic, strong) UIImageView *statusImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@end
