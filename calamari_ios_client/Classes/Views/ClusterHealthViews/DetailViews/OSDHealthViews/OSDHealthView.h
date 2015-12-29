//
//  OSDHealthView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSDHeaderView.h"

@interface OSDHealthView : UIView

@property (nonatomic, strong) UIImageView *okView;
@property (nonatomic, strong) UILabel *okLabel;
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) OSDHeaderView *osdHealthToolBar;

@end
