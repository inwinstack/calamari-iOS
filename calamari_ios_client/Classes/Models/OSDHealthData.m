//
//  OSDHealthData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDHealthData.h"

@implementation OSDHealthData

+ (OSDHealthData*) shareInstance {
    static OSDHealthData *osdHealthData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        osdHealthData = [[OSDHealthData alloc] init];
    });
    return osdHealthData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.osdArray = [NSMutableArray array];
    }
    return self;
}

@end
