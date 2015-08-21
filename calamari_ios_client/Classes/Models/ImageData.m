//
//  ImageData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/14.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData

+ (ImageData*) shareInstance {
    static ImageData *imageData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageData = [[ImageData alloc] init];
    });
    return imageData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.imageNameDictionary = @{@"HealthImages" : @[@"HeartImage", @"OSDImage", @"MONImage", @"PoolImage", @"HostImage", @"PGImage", @"UsageImage", @"IOPSImage"]};
    }
    return self;
}

@end
