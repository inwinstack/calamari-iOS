//
//  UserData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+ (UserData*) shareInstance {
    static UserData *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[UserData alloc] init];
    });
    return userData;
}

@end
