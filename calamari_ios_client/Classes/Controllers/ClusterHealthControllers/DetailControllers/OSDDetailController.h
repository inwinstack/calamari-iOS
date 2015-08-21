//
//  OSDDetailController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "BaseController.h"

typedef NS_ENUM(NSUInteger, OSDDetailType) {
    OSDDetailOKType,
    OSDDetailWarnType,
    OSDDetailErrorType,
};

@class OSDDetailView;

@interface OSDDetailController : BaseController

@property (nonatomic) OSDDetailType OSDdetailType;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong) OSDDetailView *osdDetailView;

@end
