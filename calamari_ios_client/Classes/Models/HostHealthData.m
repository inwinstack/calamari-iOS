//
//  HostHealthData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostHealthData.h"

@implementation HostHealthData

+ (HostHealthData*) shareInstance {
    static HostHealthData *hostHealthData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hostHealthData = [[HostHealthData alloc] init];
    });
    return hostHealthData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.hostArray = [NSMutableArray array];
        self.hostDic = [NSMutableDictionary dictionary];
        self.hostAllData = [NSMutableDictionary dictionary];
        self.hostAllCPUKeyArray = [NSMutableArray array];
    }
    return self;
}

@end
