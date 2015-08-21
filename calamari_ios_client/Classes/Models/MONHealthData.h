//
//  MONHealthData.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MONHealthData : NSObject

@property (nonatomic, strong) NSMutableArray *monArray;

+ (MONHealthData*) shareInstance;

- (void) startSort;
- (NSString*) checkMonWithNodeName:(NSString*)nodeName;

@end
