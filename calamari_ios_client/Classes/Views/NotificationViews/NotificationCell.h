//
//  NotificationCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UICollectionViewCell

@property (nonatomic, strong) CAShapeLayer *statusColorView;
@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *archiveButton;
@property (nonatomic, strong) UILabel *statusTimeLabel;

- (void) reloadLayout;

@end
