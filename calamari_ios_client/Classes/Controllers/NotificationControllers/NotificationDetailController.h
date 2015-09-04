//
//  NotificationDetailController.h
//  calamari_ios_client
//
//  Created by Francis on 2015/9/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "BaseController.h"

@class NotificationDetailView;

@interface NotificationDetailController : BaseController

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NotificationDetailView *notificationDetailView;

@end
