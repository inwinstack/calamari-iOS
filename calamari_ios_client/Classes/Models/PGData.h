//
//  PGData.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/29.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGData : NSObject

@property (nonatomic, strong) NSArray *criticalArray;
@property (nonatomic, strong) NSArray *warnArray;
@property (nonatomic, strong) NSArray *okArray;
@property (nonatomic, strong) NSDictionary *pgKeyDic;
@property (nonatomic, strong) NSString *criticalCount;
@property (nonatomic, strong) NSString *warnCount;
@property (nonatomic, strong) NSString *okCount;
@property (nonatomic, strong) NSMutableDictionary *pgDic;

+ (PGData*) shareInstance;

@end
