//
//  APIRecord.m
//  CephAPITest
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "APIRecord.h"

@implementation APIRecord

+ (APIRecord*) shareInstance {
    static APIRecord *apiRecord = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiRecord = [[APIRecord alloc] init];
    });
    return apiRecord;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.APIDictionary = @{@"Space" : @[@"v1", @"space"], @"Server" : @[@"v1", @"server"], @"OSD" : @[@"v1", @"osd"], @"MON" : @[@"v2", @"mon"], @"Health" : @[@"v1", @"health"], @"Health_Counter" : @[@"v1", @"health_counters"], @"Pools" : @[@"v1", @"pool"], @"Hosts" : @[@"v1", @"server"], @"OSD" : @[@"v2", @"osd"], @"MON" : @[@"v2", @"mon"]};
    }
    return self;
}

@end
