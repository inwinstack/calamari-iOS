//
//  ClusterData.h
//  CephAPITest
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClusterData : NSObject

@property (nonatomic, strong) NSMutableArray *clusterArray;
@property (nonatomic, strong) NSMutableDictionary *clusterDetailData;
@property (nonatomic, strong) NSArray *serviceNameArray;
@property (nonatomic, strong) NSArray *unitArray;

+ (ClusterData*) shareInstance;

- (NSString*) getCurrentStatusWithID:(NSString*)clusterID;
- (NSString*) getLastUpdateTimeWithID:(NSString*)clusterID;
- (NSString*) getCurrentValueWithStatus:(NSString*)status service:(NSString*)service clusterID:(NSString*)clusterID;
- (void) setData:(NSString*)clusterID completion:(void (^)(BOOL finished))completion;
- (NSString*) caculateByte:(double)value;
- (void) setData;

@end
