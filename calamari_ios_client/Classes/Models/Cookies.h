//
//  Cookies.h
//  CephAPITest
//
//  Created by Francis on 2015/4/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cookies : NSObject

@property (nonatomic, strong) NSString *sessionID;

+ (Cookies*) shareInstance;

- (void) clearCookies;

@end
