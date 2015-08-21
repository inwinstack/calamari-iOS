//
//  MONHealthController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "BaseController.h"

@class MONHealthView;
@class MONHealthFlowLayout;

@interface MONHealthController : BaseController

@property (nonatomic, strong) MONHealthView *monHealthView;
@property (nonatomic, strong) MONHealthFlowLayout *flowLayout;

@end
