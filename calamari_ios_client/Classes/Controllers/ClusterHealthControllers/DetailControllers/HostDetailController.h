//
//  HostDetailController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/7/2.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "BaseController.h"

@class HostDetailView;

@interface HostDetailController : BaseController

@property (nonatomic, strong) NSString *navigationTitle;
@property (nonatomic, strong) HostDetailView *hostDetailView;

@end
