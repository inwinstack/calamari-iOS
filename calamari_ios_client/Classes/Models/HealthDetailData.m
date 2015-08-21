//
//  HealthDetailData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HealthDetailData.h"

@implementation HealthDetailData

+ (HealthDetailData*) shareInstance {
    static HealthDetailData *healthDetailData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        healthDetailData = [[HealthDetailData alloc] init];
    });
    return healthDetailData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.detailArray = [NSMutableArray array];
    }
    return self;
}

@end
