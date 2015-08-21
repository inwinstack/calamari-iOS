//
//  HostHealthData.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostHealthData : NSObject

@property (nonatomic, strong) NSMutableArray *hostArray;
@property (nonatomic, strong) NSMutableArray *hostAllCPUKeyArray;
@property (nonatomic, strong) NSMutableDictionary *hostDic;
@property (nonatomic, strong) NSMutableDictionary *hostAllData;

+ (HostHealthData*) shareInstance;

@end
