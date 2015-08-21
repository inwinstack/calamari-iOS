//
//  OSDHealthController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "BaseController.h"

@class OSDHealthView;
@class OSDViewFLowLayout;
@class OSDDetailController;
@class ErrorView;

@interface OSDHealthController : BaseController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) OSDHealthView *osdHealthView;
@property (nonatomic, strong) OSDViewFLowLayout *flowLayout;
@property (nonatomic, strong) OSDDetailController *osdDetailController;
@property (nonatomic, strong) ErrorView *errorView;

@end
