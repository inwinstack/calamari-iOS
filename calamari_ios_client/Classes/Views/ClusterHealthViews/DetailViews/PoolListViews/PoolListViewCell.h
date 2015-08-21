//
//  PoolListViewCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/7/2.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoolListViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UIImageView *replicasImage;
@property (nonatomic, strong) UIImageView *pgImage;
@property (nonatomic, strong) UILabel *pgNumberLabel;
@property (nonatomic, strong) UILabel *replicasNumberLabel;
@property (nonatomic, strong) UILabel *replicasLabel;
@property (nonatomic, strong) UILabel *pgLabel;

- (void) reloadLayout;

@end
