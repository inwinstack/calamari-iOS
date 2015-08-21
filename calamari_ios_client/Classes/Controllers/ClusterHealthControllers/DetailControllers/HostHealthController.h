//
//  HostHealthController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "BaseController.h"

@class HostHealthView;
@class HostHealthFlowLayout;
@class HostDetailController;

@interface HostHealthController : BaseController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) HostHealthView *hostHealthView;
@property (nonatomic, strong) HostHealthFlowLayout *hostHealthFlowLayout;
@property (nonatomic, strong) HostDetailController *hostDetailController;

@end
