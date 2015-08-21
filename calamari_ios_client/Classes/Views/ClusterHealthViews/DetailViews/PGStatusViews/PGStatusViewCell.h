//
//  PGStatusViewCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/27.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGStatusViewCell : UICollectionViewCell

@property (nonatomic, strong) CAShapeLayer *colorView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *pgsLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end
