//
//  APIRecord.h
//  CephAPITest
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRecord : NSObject

@property (nonatomic, strong) NSDictionary *APIDictionary;

+ (APIRecord*) shareInstance;

@end
