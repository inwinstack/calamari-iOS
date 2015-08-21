//
//  HostDetailView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/7/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HostDetailHeaderView;

@interface HostDetailView : UIView

@property (nonatomic, strong) HostDetailHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *hostDetailCollectionView;

@end
