//
//  HealthDetailController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@class HealthDetailView;

@interface HealthDetailController : BaseController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) HealthDetailView *healthDetailView;

@end
