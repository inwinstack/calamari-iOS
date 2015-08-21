//
//  Cookies.m
//  CephAPITest
//
//  Created by Francis on 2015/4/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "Cookies.h"

@implementation Cookies

+ (Cookies*) shareInstance {
    static Cookies *cookies = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cookies = [[Cookies alloc] init];
    });
    return cookies;
}

- (void) clearCookies {
    _sessionID = @"";
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
}

@end
