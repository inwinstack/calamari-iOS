//
//  CustomNavigationController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/7/20.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClusterHealthController;
@class ChartController;
@class MutualController;
@class HealthDetailController;
@class OSDHealthController;
@class MONHealthController;
@class HostHealthController;
@class PGStatusController;
@class UsageController;
@class PoolIOPSController;
@class PoolListController;

@interface CustomNavigationController : UINavigationController

@property (nonatomic, strong) ClusterHealthController *healthController;
@property (nonatomic, strong) ChartController *chartController;
@property (nonatomic, strong) MutualController *mutualController;
@property (nonatomic, strong) HealthDetailController *healthDetailController;
@property (nonatomic, strong) OSDHealthController *osdHealthController;
@property (nonatomic, strong) MONHealthController *monHealthController;
@property (nonatomic, strong) HostHealthController *hostHealthController;
@property (nonatomic, strong) PGStatusController *pgStatusController;
@property (nonatomic, strong) UsageController *usageController;
@property (nonatomic, strong) PoolIOPSController *poolIOPSController;
@property (nonatomic, strong) PoolListController *poolListController;

@end
