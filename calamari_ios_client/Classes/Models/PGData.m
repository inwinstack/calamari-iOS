//
//  PGData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/29.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PGData.h"

@implementation PGData

+ (PGData*) shareInstance {
    static PGData *pgData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pgData = [[PGData alloc] init];
    });
    return pgData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.criticalArray = @[@"down", @"stale", @"peering", @"incomplete", @"inconsistent"];
        self.warnArray = @[@"creating", @"replaying", @"splitting", @"scrubbing", @"degraded", @"repair", @"recovering", @"backfill", @"wait-backfill", @"remapped"];
        self.okArray = @[@"clean", @"active"];
        self.pgDic = [NSMutableDictionary dictionary];
        self.pgKeyDic = @{@"down" : @"Down", @"stale" : @"Stale", @"peering" : @"Peering", @"incomplete" : @"Incomplete", @"inconsistent" : @"Inconsistent", @"creating" : @"Creating", @"replaying" : @"Replaying", @"splitting" : @"Splitting", @"scrubbing" : @"Scrubbing", @"degraded" : @"degraded", @"repair" : @"Repair", @"recovering" : @"Recovering", @"backfill" : @"Backfill", @"wait-backfill" : @"Wait-Backfill", @"remapped" : @"Remapped", @"clean" : @"Clean", @"active" : @"Active"};
    }
    return self;
}

@end
